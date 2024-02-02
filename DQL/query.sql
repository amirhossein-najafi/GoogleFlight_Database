--All flights of a specific user in a specific period of time.
  
1)select flights.* from flights
join bookings using(flight_id)
join payment using (booking_id)
join users using (user_id)
where users.user_id=15 and bookings.booking_datetime between '2022-11-29' and '2023-11-29'

--The number of flights made with a specific aircraft in a specific period of time
2)
select count(flight_id) from flights
join aircrafts using (aircraft_id)
where aircraft_id= 3 and departure_day between '2022-11-29' and '2023-11-29'

--All payments made to an airline in a specific time period.
3)
select payment.* from payment 
join bookings using(booking_id)
join flights using(flight_id)
join airlines using(airline_id)
where airline_id=1 and payment_date between '2023-04-27 04:43:58' and '2023-05-27 04:43:58'

--Baggage of passengers along with their information on a specific flight.
4)
select users.*,baggage.* from baggage
join users  using(user_id) 
join payment using (user_id)
join bookings using(booking_id)
join flights using(flight_id)
where flights.flight_id =14


--The names of the crew flying a particular flight
5)
select first_name , last_name from crew
join airports using (airport_id)
join flights using(airport_id)
where flights.flight_id=15

extra 1)
select airlines.name from feedback
join flights using(flight_id)
join airlines using(airline_id)
group by airlines.name
order by sum(rating) desc
limit 1


--1)all crew that work in specify airport

select first_name , last_name from crew
join airports using (airport_id)
where airport_id=1



--2)users information that feedback specify flight

select users.*,feedback.* from feedback 
natural join users 
where flight_id=3


--3)users information that flight with  specify aircraft
select users.* from aircrafts
natural join flights 
natural join bookings
natural join payment
natural join users
where aircrafts.aircraft_id=3



--4)all the price of one flight
select price,bookings.* from payment
join bookings using(booking_id)
where flight_id=14

--5)all the price of  one airline
select price from payment
join bookings using(booking_id)
join flights using (flight_id)
where airline_id=10 
