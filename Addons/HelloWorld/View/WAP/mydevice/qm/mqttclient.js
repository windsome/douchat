var mqtt;
var reconnectTimeout = 2000;

function MQTTconnect() {
    mqtt = new Paho.MQTT.Client(
        host,
        port,
        "web_" + parseInt(Math.random() * 100,10));
    var options = {
        timeout: 3,
        useSSL: useTLS,
        cleanSession: cleansession,
        onSuccess: onConnect,
        onFailure: function (message) {
            $('#status').val("Connection failed: " + message.errorMessage + "Retrying");
            setTimeout(MQTTconnect, reconnectTimeout);
        }
    };

    mqtt.onConnectionLost = onConnectionLost;
    mqtt.onMessageArrived = onMessageArrived;

    if (username != null) {
        options.userName = username;
        options.password = password;
    }
    console.log("Host="+ host + ", port=" + port + " TLS = " + useTLS + " username=" + username + " password=" + password);
    mqtt.connect(options);
}

function onConnect() {
    $('#status').val('Connected to ' + host + ':' + port);
    // Connection succeeded; subscribe to our topic
    mqtt.subscribe(topic, {qos: 0});
    $('#topic').val(topic);
}

function onConnectionLost(response) {
    setTimeout(MQTTconnect, reconnectTimeout);
    $('#status').val("connection lost: " + responseObject.errorMessage + ". Reconnecting");
};

function onMessageArrived(message) {
    var topic = message.destinationName;
    var payload = message.payloadString;

    $('#ws').prepend('<li>' + topic + ' = ' + payload + '</li>');
};

function button_onclick(){
	//这里写你要执行的语句
	var tp = $('#sendtopic').val();
	var val = $('#textsend').val();
	if(tp==''||val=='')
	{
		alert("no aaa");
		return;
	}
	var message = new Paho.MQTT.Message(val);
	message.destinationName = tp;
	message.qos=0;
	mqtt.send(message);
    //		mqtt.publish(tp, 0, val);
    $('#ws').prepend('<li>' + tp + ' = ' + val+ '</li>');
};
