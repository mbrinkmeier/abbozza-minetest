Queue = {
	head = -1,
	tail = 0,
	values = {},
	cap = 10
}

-- states of the queue
-- head == tail => queue is empty

function Queue:new(newInstance)
	newInstance = newInstance or {}
	setmetatable(newInstance, self)
	self.__index = self
	return newInstance
end


function Queue:isEmpty()
   return self.head == -1
end


function Queue:enqueue(value)
   -- add value
	self.values[self.tail] = value   
	-- if tail == head, the queue is full, drop the head
	if self.head == -1 then
	   self.head = 0
	elseif self.tail == self.head then
	   self.head = self.head + 1
		self.head = self.head - math.floor(self.head/self.cap) * self.cap
	end
	-- add value a position tail+1
	self.tail = self.tail + 1
	self.tail = self.tail - math.floor(self.tail/self.cap) * self.cap
end


function Queue:dequeue()
   if self.head == -1 then return nil end 
	local value = self.values[self.head]
	self.head = self.head + 1
   self.head = self.head - math.floor(self.head/self.cap) * self.cap
   -- if head == tail the queue is empty
   if self.head == self.tail then
      self.head = -1
      self.tail = 0
   end
   return value
end