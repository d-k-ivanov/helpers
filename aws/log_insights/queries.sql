
-- Check error messages in the Log Group
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 20
