import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/children_park_controller.dart';
import 'package:town_pass/page/children_park/model/children_park_models.dart';
import 'package:town_pass/page/children_park/widgets/children_park_widgets.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_text.dart';

class ChildrenParkProfilePage extends GetView<ChildrenParkController> {
  const ChildrenParkProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = controller.userProfile;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const ParkSearchBar(hint: 'Profile / 個人服務'),
            const SizedBox(height: 16),
            _ProfileCard(profile: profile),
            const SizedBox(height: 12),
            const _IntegratedServices(),
            const SizedBox(height: 12),
            const _TrafficCard(),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final ParkUserProfile profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEDFAFF), Color(0xFFFFFFFF)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TPColors.primary100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: TPColors.primary200,
                child: Icon(Icons.person, color: TPColors.primary800),
              ),
              SizedBox(width: 10),
              TPText(
                'Visitor',
                style: TPTextStyles.h3SemiBold,
                color: TPColors.grayscale900,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _RowItem(label: '會員等級', value: profile.memberLevel),
          _RowItem(label: '入園狀態', value: profile.checkInStatus),
          _RowItem(label: '入園時間', value: profile.checkInTime),
          _RowItem(label: '常用路線', value: profile.preferredRoute),
          _RowItem(label: '提醒設定', value: profile.reminderSetting),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;

  const _RowItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TPText(
              label,
              style: TPTextStyles.bodyRegular,
              color: TPColors.grayscale600,
            ),
          ),
          TPText(
            value,
            style: TPTextStyles.bodySemiBold,
            color: TPColors.grayscale900,
          ),
        ],
      ),
    );
  }
}

class _IntegratedServices extends StatelessWidget {
  const _IntegratedServices();

  @override
  Widget build(BuildContext context) {
    const services = [
      '身分驗證',
      '收藏設施',
      '活動提醒',
      '親子會員設定',
      '消費紀錄',
      '交通通知',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TPText(
            '台北通整合服務',
            style: TPTextStyles.h3SemiBold,
            color: TPColors.grayscale900,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: services
                .map(
                  (service) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: TPColors.primary50,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: TPText(
                      service,
                      style: TPTextStyles.caption,
                      color: TPColors.primary700,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TrafficCard extends StatelessWidget {
  const _TrafficCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TPText(
            '交通資訊',
            style: TPTextStyles.h3SemiBold,
            color: TPColors.grayscale900,
          ),
          SizedBox(height: 10),
          TPText('捷運：劍潭站轉乘公車',
              style: TPTextStyles.bodyRegular, color: TPColors.grayscale700),
          SizedBox(height: 4),
          TPText('公車：兒童新樂園站',
              style: TPTextStyles.bodyRegular, color: TPColors.grayscale700),
          SizedBox(height: 4),
          TPText('停車場：尚有 42 位',
              style: TPTextStyles.bodyRegular, color: TPColors.grayscale700),
          SizedBox(height: 4),
          TPText('建議：週末建議搭乘大眾運輸',
              style: TPTextStyles.bodyRegular, color: TPColors.grayscale700),
        ],
      ),
    );
  }
}
