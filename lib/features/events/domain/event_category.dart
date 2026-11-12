enum EventCategory {
  clubs,
  conferences,
  hackathons,
  workshops,
  community;

  String get label => switch (this) {
    EventCategory.clubs => 'Clubs',
    EventCategory.conferences => 'Conferences',
    EventCategory.hackathons => 'Hackathons',
    EventCategory.workshops => 'Workshops',
    EventCategory.community => 'Community',
  };
}
