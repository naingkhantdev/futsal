import '../../responses/booking_response.dart';
import '../../vos/booking_vo.dart';

extension BookingResponseMapper on BookingResponse {
  BookingVO toVO() => BookingVO(
        id: id,
        shopId: shopId,
        customerId: customerId,
        stadiumId: stadiumId,
        courtId: courtId,
        bookingDate: bookingDate,
        startMinute: startMinute,
        endMinute: endMinute,
        slotMinutes: slotMinutes,
        startAt: startAt,
        endAt: endAt,
        pricePerHour: pricePerHour,
        totalPrice: totalPrice,
        currency: currency,
        status: status,
        paymentStatus: paymentStatus,
        customerNameSnapshot: customerNameSnapshot,
        customerPhoneSnapshot: customerPhoneSnapshot,
        stadiumNameSnapshot: stadiumNameSnapshot,
        courtNameSnapshot: courtNameSnapshot,
        cancelledAt: cancelledAt,
        cancelReason: cancelReason,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
