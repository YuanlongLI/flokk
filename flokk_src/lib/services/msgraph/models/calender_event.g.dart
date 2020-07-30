// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calender_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarEvents _$CalendarEventsFromJson(Map<String, dynamic> json) {
  return CalendarEvents(
    value: (json['value'] as List)
        ?.map((e) => e == null
            ? null
            : CalendarEvent.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CalendarEventsToJson(CalendarEvents instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) {
  return CalendarEvent(
    id: json['id'] as String,
    createdDateTime: json['createdDateTime'] as String,
    lastModifiedDateTime: json['lastModifiedDateTime'] as String,
    changeKey: json['changeKey'] as String,
    categories: (json['categories'] as List)?.map((e) => e as String)?.toList(),
    originalStartTimeZone: json['originalStartTimeZone'] as String,
    originalEndTimeZone: json['originalEndTimeZone'] as String,
    iCalUId: json['iCalUId'] as String,
    reminderMinutesBeforeStart: json['reminderMinutesBeforeStart'] as int,
    isReminderOn: json['isReminderOn'] as bool,
    hasAttachments: json['hasAttachments'] as bool,
    subject: json['subject'] as String,
    bodyPreview: json['bodyPreview'] as String,
    importance: json['importance'] as String,
    sensitivity: json['sensitivity'] as String,
    isAllDay: json['isAllDay'] as bool,
    isCancelled: json['isCancelled'] as bool,
    isOrganizer: json['isOrganizer'] as bool,
    responseRequested: json['responseRequested'] as bool,
    seriesMasterId: json['seriesMasterId'] as String,
    showAs: json['showAs'] as String,
    type: json['type'] as String,
    webLink: json['webLink'] as String,
    onlineMeetingUrl: json['onlineMeetingUrl'] as String,
    isOnlineMeeting: json['isOnlineMeeting'] as bool,
    onlineMeetingProvider: json['onlineMeetingProvider'] as String,
    allowNewTimeProposals: json['allowNewTimeProposals'] as bool,
    recurrence: json['recurrence'] as String,
    onlineMeeting: json['onlineMeeting'] == null
        ? null
        : OnlineMeeting.fromJson(json['onlineMeeting'] as Map<String, dynamic>),
    responseStatus: json['responseStatus'] == null
        ? null
        : ResponseStatus.fromJson(
            json['responseStatus'] as Map<String, dynamic>),
    body: json['body'] == null
        ? null
        : Body.fromJson(json['body'] as Map<String, dynamic>),
    start: json['start'] == null
        ? null
        : Start.fromJson(json['start'] as Map<String, dynamic>),
    end: json['end'] == null
        ? null
        : End.fromJson(json['end'] as Map<String, dynamic>),
    location: json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    locations: (json['locations'] as List)
        ?.map((e) =>
            e == null ? null : Location.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    attendees: (json['attendees'] as List)
        ?.map((e) =>
            e == null ? null : Attendee.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    organizer: json['organizer'] == null
        ? null
        : EmailAddress.fromJson(json['organizer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CalendarEventToJson(CalendarEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdDateTime': instance.createdDateTime,
      'lastModifiedDateTime': instance.lastModifiedDateTime,
      'changeKey': instance.changeKey,
      'categories': instance.categories,
      'originalStartTimeZone': instance.originalStartTimeZone,
      'originalEndTimeZone': instance.originalEndTimeZone,
      'iCalUId': instance.iCalUId,
      'reminderMinutesBeforeStart': instance.reminderMinutesBeforeStart,
      'isReminderOn': instance.isReminderOn,
      'hasAttachments': instance.hasAttachments,
      'subject': instance.subject,
      'bodyPreview': instance.bodyPreview,
      'importance': instance.importance,
      'sensitivity': instance.sensitivity,
      'isAllDay': instance.isAllDay,
      'isCancelled': instance.isCancelled,
      'isOrganizer': instance.isOrganizer,
      'responseRequested': instance.responseRequested,
      'seriesMasterId': instance.seriesMasterId,
      'showAs': instance.showAs,
      'type': instance.type,
      'webLink': instance.webLink,
      'onlineMeetingUrl': instance.onlineMeetingUrl,
      'isOnlineMeeting': instance.isOnlineMeeting,
      'onlineMeetingProvider': instance.onlineMeetingProvider,
      'allowNewTimeProposals': instance.allowNewTimeProposals,
      'recurrence': instance.recurrence,
      'onlineMeeting': instance.onlineMeeting,
      'responseStatus': instance.responseStatus,
      'body': instance.body,
      'start': instance.start,
      'end': instance.end,
      'location': instance.location,
      'locations': instance.locations,
      'attendees': instance.attendees,
      'organizer': instance.organizer,
    };

ResponseStatus _$ResponseStatusFromJson(Map<String, dynamic> json) {
  return ResponseStatus(
    response: json['response'] as String,
    time: json['time'] as String,
  );
}

Map<String, dynamic> _$ResponseStatusToJson(ResponseStatus instance) =>
    <String, dynamic>{
      'response': instance.response,
      'time': instance.time,
    };

Start _$StartFromJson(Map<String, dynamic> json) {
  return Start(
    dateTime: json['dateTime'] as String,
    timeZone: json['timeZone'] as String,
  );
}

Map<String, dynamic> _$StartToJson(Start instance) => <String, dynamic>{
      'dateTime': instance.dateTime,
      'timeZone': instance.timeZone,
    };

End _$EndFromJson(Map<String, dynamic> json) {
  return End(
    dateTime: json['dateTime'] as String,
    timeZone: json['timeZone'] as String,
  );
}

Map<String, dynamic> _$EndToJson(End instance) => <String, dynamic>{
      'dateTime': instance.dateTime,
      'timeZone': instance.timeZone,
    };

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    displayName: json['displayName'] as String,
    locationType: json['locationType'] as String,
    uniqueId: json['uniqueId'] as String,
    uniqueIdType: json['uniqueIdType'] as String,
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'locationType': instance.locationType,
      'uniqueId': instance.uniqueId,
      'uniqueIdType': instance.uniqueIdType,
    };

Attendee _$AttendeeFromJson(Map<String, dynamic> json) {
  return Attendee(
    type: json['type'] as String,
    status: json['status'] == null
        ? null
        : ResponseStatus.fromJson(json['status'] as Map<String, dynamic>),
    emailAddress: json['emailAddress'] == null
        ? null
        : EmailAddress.fromJson(json['emailAddress'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AttendeeToJson(Attendee instance) => <String, dynamic>{
      'type': instance.type,
      'status': instance.status,
      'emailAddress': instance.emailAddress,
    };

OnlineMeeting _$OnlineMeetingFromJson(Map<String, dynamic> json) {
  return OnlineMeeting(
    joinUrl: json['joinUrl'] as String,
  );
}

Map<String, dynamic> _$OnlineMeetingToJson(OnlineMeeting instance) =>
    <String, dynamic>{
      'joinUrl': instance.joinUrl,
    };