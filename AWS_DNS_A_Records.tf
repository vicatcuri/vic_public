###############################################################################
# A records
###############################################################################

# webvpn1.curi.com
resource "aws_route53_record" "webvpn1_curi_com" {
  provider = aws.primary
  zone_id  = aws_route53_zone.curi_com.zone_id
  name     = "webvpn1"
  type     = "A"
  ttl      = "7200"
  records  = ["4.18.201.98"]
}

# webvpn2.curi.com
resource "aws_route53_record" "webvpn2_curi_com" {
  provider = aws.primary
  zone_id  = aws_route53_zone.curi_com.zone_id
  name     = "webvpn2"
  type     = "A"
  ttl      = "7200"
  records  = ["71.16.104.50"]
}