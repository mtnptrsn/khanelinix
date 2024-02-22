local settings = require("settings")
local colors = require("colors")
local icons = require("icons")
local debug = require("debug")

local popup_toggle = "sketchybar --set $NAME popup.drawing=toggle"

local weather_icon = sbar.add("item", "weather_icon", {
  icon = {
    align = "right",
    padding_left = 12,
    padding_right = 2,
    string = "",
  },
  background = {
    padding_right = -15
  },
  position = "right",
  y_offset = 6,
})

local weather_temp = sbar.add("item", "weather_temp", {
  label = {
    align = "right",
    padding_left = 0,
    padding_right = 0,
    string = "temp",
  },
  background = {
    padding_right = -30,
    padding_left = 5
  },
  popup = {
    align = "right",
    height = 20,
  },
  update_freq = 300,
  position = "right",
  y_offset = -8,
  click_script = popup_toggle,
})

local weather_details = sbar.add("item", "weather_details", {
  icon = {
    background = {
      height = 2,
      y_offset = -12,
    },
    font = {
      family = settings.font,
      style = "Bold",
      size = 14.0,
    },
  },
  background = {
    corner_radius = 12
  },
  drawing = false,
  padding_right = 7,
  padding_left = 7,
  click_script = "sketchybar --set $NAME popup.drawing=off",
})

local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

-- Update function
weather_temp:subscribe({ "routine", "forced" }, function()
  -- Reset popup state
  weather_temp:set({ popup = { drawing = false } })

  -- Fetch events from calendar
  local forecast = io.popen("wttrbar --fahrenheit --ampm")
      :read("*a")

  -- Extract icon and temperature
  local text_start, text_end = string.find(forecast, '"text":', 1, true)                                    -- Start search from index 1
  if text_start and text_end then
    local text_value = string.sub(forecast, text_start + 8, string.find(forecast, ',', text_start + 8) - 2) -- Find comma after "text"

    for i, value in ipairs(split(text_value)) do
      -- first part of response is icon
      if i == 1 then
        weather_icon:set({ icon = { string = value } })
      end
      -- second part of response is temperature
      if i == 2 then
        weather_temp:set({ label = { string = value .. "°" } })
      end
    end
  end

  -- Clear existing events in tooltip
  local existingEvents = weather_temp:query()
  if existingEvents.popup and next(existingEvents.popup.items) ~= nil then
    for _, item in pairs(existingEvents.popup.items) do
      sbar.remove(item)
    end
  end

  -- Extract tooltip using similar approach
  local tooltip_start, tooltip_end = string.find(forecast, '"tooltip":', 1, true)
  if tooltip_start and tooltip_end then
    local tooltip_value = string.sub(forecast, tooltip_start + 11,
      string.find(forecast, '}', tooltip_start + 12) - 2) -- Find closing curly brace after "tooltip"

    for _, line in ipairs(split(tooltip_value, "\\\n")) do
      -- NOTE: dumb workaround for splitting not behaving
      if string.sub(line, 1, 1) == 'n' then
        line = string.sub(line, 2)
      end

      if string.find(line, "<b>") then
        local replacedString = string.gsub(line, "<b>", "")
        replacedString = string.gsub(replacedString, "</b>", "")

        local weather_event_title = sbar.add("item", "weather_event_title_" .. _, {
          icon = {
            drawing = true,
            string = replacedString,
          },
          label = {
            drawing = false
          },
          position = "popup." .. weather_temp.name,
          click_script = "sketchybar --set $NAME popup.drawing=off",
        })
      else
        local weather_event = sbar.add("item", "weather_event_" .. _, {
          icon = {
            drawing = false
          },
          label = {
            string = line,
            drawing = true
          },
          position = "popup." .. weather_temp.name,
          click_script = "sketchybar --set $NAME popup.drawing=off",
        })
      end
    end
  end
end)

weather_temp:subscribe("mouse.entered", function()
  weather_temp:set({ popup = { drawing = true } })
end)

weather_temp:subscribe({
    "mouse.exited.global",
    "mouse.exited"
  },
  function()
    weather_temp:set({ popup = { drawing = false } })
  end)
