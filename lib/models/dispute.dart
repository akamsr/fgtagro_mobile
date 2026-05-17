import 'package:hive_ce/hive.dart';

part 'dispute.g.dart';

@HiveType(typeId: 34)
class DisputeModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String disputeNumber;
  @HiveField(2)
  final String orderId;
  @HiveField(3)
  final String buyerId;
  @HiveField(4)
  final String sellerId;
  @HiveField(5)
  final String disputeType; // broken_item, missing_item, etc.
  @HiveField(6)
  final String subject;
  @HiveField(7)
  final List<String> evidenceLinks;
  @HiveField(8)
  final double refundRequested;
  @HiveField(9)
  final String status; // pending, in_progress, resolved, closed
  @HiveField(10)
  final String? resolutionType; // full_refund, partial_refund, rejected
  @HiveField(11)
  final bool requiresPhysicalInspection;
  @HiveField(12)
  final String? inspectionStoreId;
  @HiveField(13)
  final DateTime? inspectionScheduledAt;
  @HiveField(14)
  final String? inspectionReport;
  @HiveField(15)
  final String? inspectedBy;
  @HiveField(16)
  final DateTime createdAt;

  DisputeModel({
    required this.id,
    required this.disputeNumber,
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
    required this.disputeType,
    required this.subject,
    this.evidenceLinks = const [],
    required this.refundRequested,
    required this.status,
    this.resolutionType,
    this.requiresPhysicalInspection = false,
    this.inspectionStoreId,
    this.inspectionScheduledAt,
    this.inspectionReport,
    this.inspectedBy,
    required this.createdAt,
  });

  factory DisputeModel.fromJson(Map<String, dynamic> json) {
    return DisputeModel(
      id: json['id']?.toString() ?? '',
      disputeNumber: json['dispute_number'] ?? '',
      orderId: json['order_id']?.toString() ?? '',
      buyerId: json['buyer_id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      disputeType: json['dispute_type'] ?? '',
      subject: json['subject'] ?? '',
      evidenceLinks: json['evidence_links'] != null ? List<String>.from(json['evidence_links']) : [],
      refundRequested: (json['refund_requested'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      resolutionType: json['resolution_type'],
      requiresPhysicalInspection: json['requires_physical_inspection'] ?? false,
      inspectionStoreId: json['inspection_store_id']?.toString(),
      inspectionScheduledAt: json['inspection_scheduled_at'] != null ? DateTime.tryParse(json['inspection_scheduled_at']) : null,
      inspectionReport: json['inspection_report'],
      inspectedBy: json['inspected_by']?.toString(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dispute_number': disputeNumber,
      'order_id': orderId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'dispute_type': disputeType,
      'subject': subject,
      'evidence_links': evidenceLinks,
      'refund_requested': refundRequested,
      'status': status,
      'resolution_type': resolutionType,
      'requires_physical_inspection': requiresPhysicalInspection,
      'inspection_store_id': inspectionStoreId,
      'inspection_scheduled_at': inspectionScheduledAt?.toIso8601String(),
      'inspection_report': inspectionReport,
      'inspected_by': inspectedBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
