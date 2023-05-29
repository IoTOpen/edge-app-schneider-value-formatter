local topicMap = {}

function handleMessage(topic, payload, retained)
    local fun = topicMap[topic]
    if fun == nil then
        return
    end

    local data = json:decode(payload)
    local pointId = fun.meta["schneider.point_id"]
    data.pointid = pointId

    local pubTopic = "obj/schneider/" .. pointId .. "/" .. fun.type
    local pubData = json:encode(data)
    mq:pub(pubTopic, pubData, false, 0)
end

function onFunctionsUpdated()
    for topic, _ in pairs(topicMap) do
        mq:unsub(topic)
    end
    topicMap = {}
    local funs = edge.findFunctions({ ["schneider.point_id"] = "*" })
    for _, fun in ipairs(funs) do
        for k, v in pairs(fun.meta) do
            if k:sub(1, #"topic_read") == "topic_read" then
                topicMap[v] = fun
                mq:sub(v, 0)
            end
        end
    end
end

function onStart()
    mq:bind("#", handleMessage)
    onFunctionsUpdated()
end