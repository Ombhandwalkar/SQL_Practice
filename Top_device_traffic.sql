---
You are analyzing network traffic data collected from multiple wireless devices. The dataset records the number of data packets sent from various devices (mac_address) to different wireless networks (SSID), along with the timestamp of each transmission.

Your task is to write a SQL query that returns, for each SSID, the maximum number of packets sent by any single device during the first 10 minutes of January 1st, 2022.


--- SQL
SELECT ssid, MAX(packet_count) AS max_number_of_packages_sent
FROM (
  SELECT ssid,
         mac_address,
         COUNT(*) AS packet_count
  FROM tdf_packet_rates
  WHERE time_captured >='2022-01-01 00:00:00'
  AND   time_captured < '2022-01-01 00:10:00'
  GROUP BY ssid, mac_address
)x
GROUP BY ssid
