
-- Get current zone.
--  wx - number: World x-coordinate.
--  wy - number: World y-coordinate.
--  return - zone offset number, its transformed coordinates, and the selected zone object itself.
function getZoneOffset(wx, wy)
  local zpoint = nil
  local zIndex = nil
  local mZone = nil
  local xOffset = 0

-- Assume 1-D horizontal zones for now.
--  for _, zone in pairs(zones) do
  for idx = 1, #zones do
    if zones[idx].state.data then
      local zId = zones[idx].state.data.id
      -- local zoneWidth = zone.state.tileset.width * zone.state.tileset.tilewidth
      local zoneWidth = settings.zone_width * settings.tile_width -- For now until the server passes the sorted zones table from left to right
      local zoneHeight = settings.zone_height * settings.tile_height -- For now until the server passes the sorted zones table from left to right
      local wxMin = -1 * zId *  zoneWidth
      local wyMin = -1 * zId *  zoneHeight
      local wxMax = wxMin - zoneWidth
      local wyMax = wyMin - zoneHeight
      --print(string.format("getZoneOffset: idx=%d, wxy=(%d,%d), zId=%d, zoneDimen=(%d,%d), wxyMin=(%d,%d), wxyMax=(%d,%d)", idx, wx, wy, zId, zoneWidth, zoneHeight, wxMin, wyMin, wxMax, wyMax))

      if wx <= wxMin and wx >= wxMax and wy <= wyMin and wy >= wyMax then
        --print("getZoneOffset: Found! zId=", zId)
        zpoint = {x = zId * wx, y = wy}
        zIndex = idx;
        mZone = zone
        break
      else
        --print("getZoneOffset: Not found! zId=", zId)
        xOffset = xOffset + zoneWidth
      end
      idx = idx + 1
    end
  end
  return zIndex, zpoint, mZone
end

function hasCollision(mZone, x, y)
  local isCollidable = false

  if mZone then
    --print("hasCollision: ", inspect(mZone.state.tileset.metadatas))
    local metadatas = mZone.state.tileset.metadatas
    local metalayer = metadatas.layers[1]
    local tileId = 0

    x = math.abs(x)
    y = math.abs(y)

    -- use 'settings' global variable for now.
    local gridx = math.ceil(x / settings.tile_width)
    local gridy = math.ceil(y / settings.tile_height)
    local metaIndex = (gridy - 1) * settings.zone_width + gridx
    local metadata = nil

    --print(string.format("[%d](%d,%d): ", metaIndex, gridx, gridy, inspect(metalayer.data[metaIndex])))
    if metalayer then
      metadata = metadatas[metalayer.data[metaIndex]]
      --print("metadata:", inspect(metadata))
    end
    if metadata then
      isCollidable = metadata.properties.collidable
    end
  end

  return isCollidable
end
