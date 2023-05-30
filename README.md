# Edge app Schneider formatter

This app subscribes to messages from sensors with `schneider.point_id`
and `schneider.building_id` set in meta-data. All messages received wil be
republished on a Schneider subsystem topic with the `pointid` value set in the
MQTT payload.

Messages created by this app are published on a subsystem topic in the
format `obj/schneider/<building-id>/<function-type>`.

## Example

Original payload:

```json
{
  "value": 27.1,
  "timestamp": 1685352954
}
```

Published for this function:

```json
{
  "id": 9999,
  "installation_id": 999,
  "type": "temperature",
  "meta": {
    "name": "Temperatur 1",
    "schneider.point_id": "12345",
    "schneider.building_id": "9876",
    "topic_read": "obj/generated/0479f3d8-3103-4382-860e-d07cc5a247cd"
  }
}
```

Resulting in the following payload being published on the
topic `obj/schneider/9876/temperature`.

```json
{
  "value": 27.1,
  "timestamp": 1685352954,
  "pointid": "12345"
}
```