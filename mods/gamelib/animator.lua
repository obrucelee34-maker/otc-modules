-- chunkname: @/modules/gamelib/animator.lua

Animator = newclass("Animator")

local ID = 0

function Animator.create(widget, args)
	args = args or {
		frameDuration = 10,
		loopCount = 1
	}

	local anim = Animator.internalCreate()

	anim.widget = nil
	anim.variables = {}
	anim.events = {}
	anim.loopCount = args.loopCount
	anim.frameDuration = args.frameDuration
	anim.widget = widget
	anim.playing = false
	anim.idCounter = 1

	return anim
end

function Animator:destroy()
	self:reset()
end

function Animator:setWidget(widget)
	self:reset()

	self.widget = widget
end

function Animator:setLoopCount(count)
	self.loopCount = count
end

function Animator:setFrameDuration(duration)
	self.frameDuration = duration
end

function Animator:setDelay(delay)
	self.delay = delay
end

function Animator:addAnim(varname, delay, time, fromVal, toVal, custom)
	if custom and custom.path and not custom.path:ends("/") then
		custom.path = custom.path .. "/"
	end

	time = math.max(time, 100)

	local entry = {
		loopCount = 0,
		id = self.idCounter,
		name = varname,
		time = time,
		values = {
			from = fromVal,
			to = toVal,
			default = custom and custom.defaultVal or toVal,
			start = self:getVal(varname)
		},
		custom = custom,
		delay = delay
	}

	self.idCounter = self.idCounter + 1
	self.variables[entry.id] = entry

	return entry.id
end

function Animator:removeAnim(id)
	if self.events[id] then
		removeEvent(self.events[id])

		self.events[id] = nil
	end

	self.variables[id] = nil
end

function Animator:reset()
	self:stop(nil, true)

	self.events = {}
	self.variables = {}
	self.widget = nil
	self.idCounter = 1
end

function Animator:play()
	local anim = self

	self:stop(nil, true)

	for _, animData in ipairs(self.variables) do
		local id = animData.id
		local varname = animData.name
		local values = animData.values
		local time = animData.time
		local delay = animData.delay
		local minv = values.from
		local maxv = values.to
		local def = values.default
		local delta = maxv - minv
		local custom = animData.custom

		animData.frameIndex = 0
		animData.numFrames = math.ceil(time / self.frameDuration)
		animData.startTime = os.clock() * 1000 + delay
		animData.endTime = animData.startTime + time

		scheduleEvent(function()
			anim.events[id] = cycleEvent(function()
				local now = os.clock() * 1000

				if now >= animData.endTime then
					anim:stop(id)

					return
				end

				local widget = anim.widget

				if not widget then
					anim:stop(id)
				else
					local deltaTime = now - animData.startTime
					local val = minv + deltaTime / time * delta

					anim:setVal(varname, val, custom)
				end
			end, anim.frameDuration)
			anim.playing = true
		end, animData.delay)
	end
end

function Animator:stop(id, isStart)
	if id then
		if self.events[id] then
			removeEvent(self.events[id])

			self.events[id] = nil
		end

		local animData = self.variables[id]

		if animData then
			local def = animData.values.default
			local start = animData.values.start
			local custom = animData.custom

			self:setVal(animData.name, isStart and start or def, custom)
		end
	else
		for k, v in pairs(self.events) do
			removeEvent(v)

			self.events[k] = nil
		end

		for id, animData in pairs(self.variables) do
			local def = animData.values.default
			local start = animData.values.start
			local custom = animData.custom

			self:setVal(animData.name, isStart and start or def, custom)
		end
	end

	if table.empty(self.events) then
		self.playing = false
	end
end

function Animator:getVal(name)
	if not self.widget then
		return nil
	end

	if name == "width" then
		return self.widget:getWidth()
	elseif name == "height" then
		return self.widget:getHeight()
	elseif name == "posX" then
		return self.widget:getX()
	elseif name == "posY" then
		return self.widget:getY()
	elseif name == "marginRight" then
		return self.widget:getMarginRight()
	elseif name == "image" then
		return self.widget:getImageSource()
	elseif name == "rotation" then
		return self.widget:getRotation()
	else
		return self.widget[name]
	end
end

function Animator:setVal(name, value, custom)
	if name == "width" then
		self.widget:setWidth(value)
	elseif name == "rotation" then
		self.widget:setRotation(value)
	elseif name == "height" then
		self.widget:setHeight(value)
	elseif name == "posX" then
		self.widget:setX(value)
	elseif name == "posY" then
		self.widget:setY(value)
	elseif name == "marginRight" then
		self.widget:setMarginRight(value)
	elseif name == "image" then
		if type(value) == "string" then
			self.widget:setImageSource(value)
		else
			if not custom then
				return
			end

			self.widget:setImageSource(custom.path .. custom.prefix .. math.floor(value))
		end
	else
		self.widget[name] = value
	end
end

function Animator:isPlaying()
	return self.playing
end
