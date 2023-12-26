 SELECT *
    FROM bookings
    WHERE car_id = 2
      AND id != 10
      AND booking_status IN (
          11,
          20
      )
      AND (
          (booking_start BETWEEN '2023-12-26 10:16:40' AND '2023-12-28 11:16:40')
          OR (booking_end BETWEEN '2023-12-26 13:16:40' AND '2023-12-28 11:16:40')
      )