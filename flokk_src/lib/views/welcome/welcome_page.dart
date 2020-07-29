import 'dart:math';

import 'package:flokk/_internal/components/fading_index_stack.dart';
import 'package:flokk/_internal/page_routes.dart';
import 'package:flokk/_internal/url_launcher/url_launcher.dart';
import 'package:flokk/api_keys.dart';
import 'package:flokk/app_extensions.dart';
import 'package:flokk/commands/contacts/refresh_contacts_command.dart';
import 'package:flokk/commands/contacts/refresh_mscontacts_command.dart';
import 'package:flokk/commands/msgraph/refresh_mscalendarevents_command.dart';
import 'package:flokk/commands/msgraph/refresh_msemails_command.dart';
import 'package:flokk/commands/msgraph/refresh_mssharedfiles_command.dart';
import 'package:flokk/commands/social/refresh_social_command.dart';
import 'package:flokk/commands/web_sign_in_command.dart';
import 'package:flokk/models/auth_model.dart';
import 'package:flokk/models/contacts_model.dart';

import 'package:flokk/services/google_rest/google_rest_auth_service.dart';
import 'package:flokk/services/google_rest/google_rest_service.dart';
import 'package:flokk/services/msgraph/msgraph_rest_service.dart';
import 'package:flokk/services/service_result.dart';
import 'package:flokk/styled_components/clickable_text.dart';
import 'package:flokk/styled_components/styled_dialogs.dart';
import 'package:flokk/styled_components/styled_progress_spinner.dart';
import 'package:flokk/styles.dart';
import 'package:flokk/themes.dart';
import 'package:flokk/views/main_scaffold/main_scaffold.dart';
import 'package:flokk/views/welcome/animated_bird_splash.dart';
import 'package:flokk/views/welcome/welcome_page_step1.dart';
import 'package:flokk/views/welcome/welcome_page_step2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:multiple_screens/multiple_screens.dart';

class WelcomePage extends StatefulWidget {
  final bool initialPanelOpen;

  const WelcomePage({Key key, this.initialPanelOpen = false}) : super(key: key);

  @override
  WelcomePageState createState() => WelcomePageState();
}

/// WelcomePage will hold the state for the sub-views, this primarily to easily avoid any issues
/// with state of [WelcomePageStep2] being lost when we re-arrange the widget tree
class WelcomePageState extends State<WelcomePage> {
  GoogleRestService googleRest;
  GoogleAuthEndpointInfo authInfo;
  String authUrl = "https://google.com";
  String authCode = "10001";
  bool httpError = false;
  bool authCodeError = false;
  int pageIndex = 0;

  // Duo platform support
  final duoPlatform = const MethodChannel('duosdk.microsoft.dev');
  bool isDuo = false;
  bool isDuoSpanned = false;
  double hingeSize = 0.0;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  set isLoading(bool value) => setState(() => _isLoading = value);

  Size prevSize;
  bool showContent;
  bool twoColumnMode = true;

  @override
  void initState() {
    showContent = widget.initialPanelOpen;
    //TODO: why is this not retreived from service provider?
    googleRest = GoogleRestService();
    loadAuthInfo();

    //Need to call signInSilently() in initState() to prevent FF from showing popup alert
    if (UniversalPlatform.isWeb) {
      final gs = GoogleSignIn(
        clientId: ApiKeys().googleWebClientId,
        scopes: ['https://www.googleapis.com/auth/contacts'],
      );
      gs.signInSilently();
    }

    MultipleScreensMethods.isAppSpannedStream().listen(
      (data) => setState(() => isDuoSpanned = data),
    );

    checkForDuo();
    super.initState();
  }

  void checkForDuo() async {
    try {
      isDuo = await duoPlatform.invokeMethod('isDualScreenDevice');
      hingeSize = await duoPlatform.invokeMethod('gethingeSize');
    } catch (_) {
      // if we fail it is likely because we aren't on a duo
    }
    print('isDualScreenDevice : $isDuo');
  }

  //TODO: This is currently firing every time the app loads, should only fire when they hit the btn, and only on desktop
  Future<void> loadAuthInfo() async {
    httpError = false;
    authCodeError = false;
    ServiceResult result = await googleRest.auth.getAuthEndpoint();
    authInfo = result.content;
    if (authInfo != null) {
      authCode = authInfo.userCode;
      authUrl = authInfo.verificationUrl;
    } else {
      httpError = true;
    }
    isLoading = false;
  }

  /// Allows someone else to tell us to open the panel
  void showPanel(value) => setState(() => showContent = value);

  void refreshDataAndLoadApp() async {
    /// Load initial contacts
    isLoading = true;
    await RefreshMSContactsCommand(context).execute();
    // build array of emails
    await RefreshContactsCommand(context).execute();
    await RefreshSocialCommand(context)
        .execute(context.read<ContactsModel>().allContacts);
    await RefreshMSCalendarEventsCommand(context).execute();
    await RefreshMSeMailsCommand(context)
        .execute("james@clarkezone.onmicrosoft.com");
    await RefreshMSSharedFilesCommand(context)
        .execute("james@clarkezone.onmicrosoft.com");

    /// Show main app view
    Navigator.push<void>(
        context,
        PageRoutes.fade(
            () => MainScaffold(), Durations.slow.inMilliseconds * .001));
  }

  void handleUrlClicked() => UrlLauncher.open(authUrl);

  void handleCodeClicked() => Clipboard.setData(ClipboardData(text: authCode));

  void handleRefreshPressed() {
    setState(() => _isLoading = true);
    loadAuthInfo();
  }

  void handleBackPressed() {
    setState(() => pageIndex = 0);
  }

  void handleMSFTPressed() async {
    MsGraphRestService grs =
        Provider.of<MsGraphRestService>(context, listen: false);
    isLoading = true;
    var token = await grs.doLogin();
    //We have a token! Update the model.
    AuthModel model = Provider.of(context, listen: false);
    model.msGraphAccessToken = token;

    //TODO auth needs to report when the token expires
    model.setExpiry(60 * 60);
    model.scheduleSave();
    // Hide panel since we know we're basically logged in now...
    setState(() => showContent = false);
    // Load main app
    refreshDataAndLoadApp();
    isLoading = false;
  }

  void handleStartPressed() async {
    if (UniversalPlatform.isWeb) {
      bool success = await WebSignInCommand(context).execute();
      // We're in :) Load main app
      if (success) refreshDataAndLoadApp();
    } else {
      setState(() => pageIndex = 1);
    }
  }

  void handleCompletePressed() async {
    if (httpError) {
      Dialogs.show(OkCancelDialog(
        message: "We are unable to authorize with Google's servers. "
            "Check your internet connection and try again.",
      ));
      return;
    }
    isLoading = true;
    authCodeError = false;
    await Future.delayed(Duration(milliseconds: 500));
    ServiceResult result =
        await googleRest.auth.authorizeDevice(authInfo.deviceCode);
    GoogleAuthResults authResults = result.content;
    if (authResults != null) {
      //We have a token! Update the model.
      AuthModel model = Provider.of(context, listen: false);
      model.googleEmail = authResults.email;
      model.googleAccessToken = authResults.accessToken;
      model.googleRefreshToken = authResults.refreshToken;
      model.setExpiry(authResults.expiresIn);
      model.scheduleSave();
      // Hide panel since we know we're basically logged in now...
      setState(() => showContent = false);
      // Load main app
      refreshDataAndLoadApp();
    } else {
      authCodeError = true;
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Provide this ViewModel/State to the sub-views, so they can easily call fxns or lookup state
    return Provider.value(value: this, child: _WelcomePageStateView());
  }
}

class _WelcomePageStateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WelcomePageState state = context.watch();
    //Check a breakpoint to see whether we want side:side view or full screen
    double columnBreakPt = PageBreaks.TabletLandscape - 100;
    state.twoColumnMode = context.widthPx > columnBreakPt || state.isDuoSpanned;
    // Calculate how wide we want the panel, add some extra width as it grows
    double contentWidth = state.isDuoSpanned
        ? MediaQuery.of(context).size.width / 2 - state.hingeSize
        : state.twoColumnMode ? 300 : double.infinity;
    if (state.twoColumnMode && !state.isDuoSpanned) {
      // For every 100px > the PageBreak add some panel width. Cap at some max width.
      double maxWidth = 700;
      contentWidth += min(maxWidth, context.widthPx * .15);
    }
    // Looks janky if Birds animate when resizing window
    // disable animations if we're rebuilding because of resize
    bool skipBirdTransition = false;
    if (state.prevSize != context.sizePx) skipBirdTransition = true;
    state.prevSize = context.sizePx;

    return Scaffold(
        backgroundColor: Colors.white,
        body: TweenAnimationBuilder<double>(
          duration: Durations.slow,
          tween: Tween(begin: 0, end: 1),
          builder: (_, value, ___) => Opacity(
            opacity: value,
            child: Center(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: state.isDuoSpanned
                          ? EdgeInsets.only(right: 20.0)
                          : EdgeInsets.all(0.0),
                      child: AnimatedBirdSplashWidget(
                        showText: state.isLoading,
                        showSpannedView:
                            !state.showContent && state.isDuoSpanned,
                      ),
                    ),
                  )
                      .opacity(1.0)
                      .padding(
                          right: (state.showContent && state.twoColumnMode
                              ? contentWidth
                              : 0),
                          animate: true)
                      .animate(
                        skipBirdTransition ? 0.seconds : Durations.slow,
                        Curves.easeOut,
                      ),
                  _WelcomeContentStack()
                      .width(contentWidth)
                      // Use an AnimatedPanel to slide the panel open/closed
                      .animatedPanelX(
                        isClosed: !state.showContent,
                        closeX: context.widthPx,
                        curve: Curves.easeOut,
                        duration: Durations.slow.inMilliseconds * .001,
                      )
                      // Pin the left side on fullscreen, respect existing width otherwise
                      .positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: state.twoColumnMode ? null : 0)
                ],
              ),
            ),
          ),
        ));
  }
}

/// Holds the 2 WelcomePages and an IndexedStack to switch between them
class _WelcomeContentStack extends StatelessWidget {
  const _WelcomeContentStack({Key key}) : super(key: key);

  void _handlePrivacyPolicyPressed(String value) {
    UrlLauncher.openHttp("https://flokk.app/privacy.html");
  }

  @override
  Widget build(BuildContext context) {
    WelcomePageState state = context.watch();
    //Bg shape is rounded on the left corners when in dual-column mode, but square in full-screen
    BorderRadius getBgShape() => state.twoColumnMode
        ? BorderRadius.only(
            topLeft: Radius.circular(Corners.s10),
            bottomLeft: Radius.circular(Corners.s10))
        : null;

    AppTheme theme = context.watch();
    return state.isLoading
        ? StyledProgressSpinner().backgroundColor(theme.accent1)
        : Stack(
            children: [
              FadingIndexedStack(
                duration: Durations.slow,
                index: state.pageIndex,
                children: <Widget>[
                  WelcomePageStep1(singleColumnMode: !state.twoColumnMode)
                      .scrollable()
                      .center(),
                  WelcomePageStep2().scrollable().center(),
                ],
              ).padding(vertical: Insets.l * 1.5).center(),
              ClickableText(
                "Privacy Policy",
                linkColor: Colors.white,
                underline: true,
                onPressed: _handlePrivacyPolicyPressed,
              ).padding(bottom: Insets.m).alignment(Alignment.bottomCenter),
            ],
          )
            .padding(horizontal: Insets.l)
            .decorated(color: theme.accent1, borderRadius: getBgShape())
            .alignment(Alignment.center)
            .width(double.infinity);
  }
}
