model MarsLanding
parameter Real force1 = 37845;
parameter Real force2 = 2250;
parameter Real thrustEndTime = 210;
parameter Real thrustDecreaseTime = 43.2;
Rocket curiosity(name="curiosity", mass(start=1038.358) );
CelestialBody mars(mass=6.39e23,radius=3.3895e6,name="mars");
equation


curiosity.thrust = if (time<thrustDecreaseTime) then force1
else if (time<thrustEndTime) then force2
else 0;
curiosity.thrust2=force1*1;
curiosity.gravity = mars.g*mars.mass /(curiosity.altitude+mars.radius)^2;
when (curiosity.altitude < 0 or curiosity.altitude >59405 ) then // termination condition
terminate("Curiosity lander touches the ground of Mars");
end when;
end MarsLanding;
