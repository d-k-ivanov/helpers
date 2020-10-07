
-- Check error messages in the Log Group
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 20

-- Get a number of exceptions per hour
filter @message like /Exception/
| stats count(*) as exceptionCount by bin(1h)
| sort exceptionCount desc

-- Get not Exceprions log entries
fields @message | filter @message not like /Exception/
