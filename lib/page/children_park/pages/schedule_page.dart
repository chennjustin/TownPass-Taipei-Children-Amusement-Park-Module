import 'package:flutter/material.dart';
import 'package:town_pass/util/tp_colors.dart';

class ChildrenParkSchedulePage extends StatefulWidget {
  const ChildrenParkSchedulePage({super.key});

  @override
  State<ChildrenParkSchedulePage> createState() =>
      _ChildrenParkSchedulePageState();
}

class _ChildrenParkSchedulePageState extends State<ChildrenParkSchedulePage> {
  int? expandedId = 1;

  static const List<String> _dates = [
    '今日 05/24',
    '明日 05/25',
    '週日 05/26',
    '週一 05/27',
  ];

  static const List<_ScheduleEvent> _events = [
    _ScheduleEvent(
      id: 0,
      time: '10:00',
      title: '夢幻城堡開門大典',
      location: '夢幻城堡大門',
    ),
    _ScheduleEvent(
      id: 1,
      time: '14:00',
      title: '夢幻大遊行',
      location: '中央廣場',
      description:
          '來自童話世界的經典角色將齊聚一堂，伴隨絢麗花車與動感歌舞，與遊客近距離互動。這是園內最受歡迎的定時活動，建議提早 15 分鐘佔位。',
      duration: '約 30 分鐘',
      tag: '熱門活動',
    ),
    _ScheduleEvent(
      id: 2,
      time: '16:30',
      title: '奇幻水舞秀',
      location: '星光湖畔',
    ),
    _ScheduleEvent(
      id: 3,
      time: '19:00',
      title: '極光煙火音樂祭',
      location: '全區天空 / 城堡廣場',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final active = index == 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? TPColors.primary700 : const Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _dates[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: active ? TPColors.white : TPColors.grayscale700,
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: _dates.length,
          ),
        ),
        const SizedBox(height: 14),
        Stack(
          children: [
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Container(width: 2, color: TPColors.grayscale100),
            ),
            Column(
              children: _events
                  .map((event) => _eventCard(
                      event: event, expanded: expandedId == event.id))
                  .toList(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F3FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: TPColors.primary700),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '活動提醒',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text('演出時間可能因天候狀況調整，請隨時關注 App 最新公告。'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _eventCard({required _ScheduleEvent event, required bool expanded}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 14),
            width: 16,
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: expanded ? 12 : 10,
              height: expanded ? 12 : 10,
              decoration: BoxDecoration(
                color: TPColors.primary700,
                shape: BoxShape.circle,
                border: Border.all(color: TPColors.white, width: 2),
                boxShadow: expanded
                    ? const [
                        BoxShadow(
                          color: Color(0x400066C2),
                          blurRadius: 8,
                        )
                      ]
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() {
                  expandedId = expanded ? null : event.id;
                });
              },
              child: Ink(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TPColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        expanded ? TPColors.primary700 : TPColors.grayscale100,
                    width: expanded ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.time,
                                style: const TextStyle(
                                  color: TPColors.primary700,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: TPColors.grayscale900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place_outlined,
                                    size: 14,
                                    color: TPColors.grayscale700,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      event.location,
                                      style: const TextStyle(
                                        color: TPColors.grayscale700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          expanded ? Icons.expand_less : Icons.expand_more,
                          color: expanded
                              ? TPColors.primary700
                              : TPColors.grayscale700,
                        ),
                      ],
                    ),
                    if (expanded && event.description != null) ...[
                      const SizedBox(height: 10),
                      Container(height: 1, color: TPColors.grayscale100),
                      const SizedBox(height: 10),
                      Text(
                        event.description!,
                        style: const TextStyle(
                            height: 1.45, color: TPColors.grayscale700),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _tagChip(
                            icon: Icons.schedule,
                            text: event.duration ?? '',
                            color: TPColors.primary700,
                            bg: const Color(0xFFE6F3FF),
                          ),
                          const SizedBox(width: 8),
                          _tagChip(
                            icon: Icons.star,
                            text: event.tag ?? '',
                            color: const Color(0xFF8A3A00),
                            bg: const Color(0xFFFFE9D8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none),
                          label: const Text('提醒我'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip({
    required IconData icon,
    required String text,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleEvent {
  final int id;
  final String time;
  final String title;
  final String location;
  final String? description;
  final String? duration;
  final String? tag;

  const _ScheduleEvent({
    required this.id,
    required this.time,
    required this.title,
    required this.location,
    this.description,
    this.duration,
    this.tag,
  });
}
