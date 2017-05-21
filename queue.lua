--
-- abbozza! minetest plugin
--
-- Copyright 2017 Michael Brinkmeier ( michael.brinkmeier@uni-osnabrueck.de )
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--   http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
--
--
-- Implementation of a simple queue.
--

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