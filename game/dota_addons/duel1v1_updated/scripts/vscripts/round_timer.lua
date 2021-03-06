-- A custom timer for starting rounds, created to allow more flexible adjustment of the
-- timer while it is running


-- Constants

round_start_timer = 0


-- Initializes the custom timer
function InitRoundStartTimer()
	Timers:RemoveTimer("round_timer")

	-- Count down the timer once per second, and send a timer update event (used in JS)
	local tick = function()
		CountDownTimer()
		SendTimerUpdateEvent()
		return 1.0
	end

	local args = {
		endTime = 1.0,
		callback = tick
	}

	Timers:CreateTimer("round_timer", args)
end


-- Sets the round start timer to the provided value (in seconds)
function SetRoundStartTimer(seconds)
	-- This is called again here so the countdown only starts after one second has passed
	-- Otherwise the countdown could happen before the first second passes and the timer becomes inaccurate
	InitRoundStartTimer()
	SendTimerUpdateEvent()
	round_start_timer = seconds
end


-- Counts down the timer by one second
function CountDownTimer()	
	if round_start_timer > 0 then
		-- Count down one second
		round_start_timer = round_start_timer - 1

		-- When the timer reaches zero, start the round
		if round_start_timer == 0 then
			StartRound()
		end
	end
end


-- Tell JS to update the number on the ready-up UI
-- to show how many seconds are left before the round starts
function SendTimerUpdateEvent()
	local data = {}
	data.timer = round_start_timer

	CustomGameEventManager:Send_ServerToAllClients("timer_update", data)
end