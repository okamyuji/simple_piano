// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
  midiNumber: (json['midiNumber'] as num).toInt(),
  noteName: json['noteName'] as String,
  octave: (json['octave'] as num).toInt(),
  frequency: (json['frequency'] as num).toDouble(),
  isWhiteKey: json['isWhiteKey'] as bool,
);

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
  'midiNumber': instance.midiNumber,
  'noteName': instance.noteName,
  'octave': instance.octave,
  'frequency': instance.frequency,
  'isWhiteKey': instance.isWhiteKey,
};
