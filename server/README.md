Entry point parser for smart-me meter using smart-me Real time API [http://wiki.smart-me.com/index.php/Developer#Realtime_.28Webhook.29_API]
Entry point has to be hosted and registered through smart-me REST API [https://smart-me.com/swagger/ui/index] using `/api/RegisterForRealtimeApi`

Additional entry points:
* `POST /startRecording`
** create a csv file and start saving data retrieved to it
* `POST /endRecording`
** stop saving to csv file
* `POST /status`
** set status if necessary (ex: on/off/idle, downloading, streaming, video game, etc.)

The csv format is the following
* timestamp: timestamp of the measure from smart-me data
* date: human readable date
* elapsed time (milliseconds): elapsed time since the start of the measure (smart-me is supposed to return 1 measure per second)
* power (W)
* status: status if set by a call to /status