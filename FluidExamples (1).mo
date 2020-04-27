within ;
package FluidExamples

  model Example1 "Simplest possible model"
    extends Modelica.Icons.Example;
    package Medium =Modelica.Media.Water.ConstantPropertyLiquidWater;
  
    Modelica.Fluid.Pipes.StaticPipe pipe(redeclare package Medium = Medium,
  diameter=1,
      length=20, m_flow_start = 5, p_a_start = 100, p_b_start = 500)
      annotation (Placement( visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0)));
        Modelica.Blocks.Sources.Ramp ramp1(
      
      duration= 50,
      height=1e5,offset=1e5,
      startTime=2) annotation (Placement(visible = true, transformation(extent = {{-122, -8}, {-102, 12}}, rotation = 0)));
    Modelica.Fluid.Sources.Boundary_pT boundary1(
      redeclare package Medium = Medium,
      T=400.15,
      use_p_in=true,
      use_T_in=false,
      nPorts=1,
      p=200000)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{60,60},{80,80}})));
    Modelica.Fluid.Sources.FixedBoundary boundary2(
      redeclare package Medium = Medium,
      T=293.15,
      nPorts=1,
      p=100000)
      annotation (Placement(transformation(extent={{82,-10},{62,10}})));
  equation
    connect(boundary1.ports[1], pipe.port_a) annotation(
      Line(points = {{-60, 0}, {-10, 0}}, color = {0, 127, 255}));
    connect(pipe.port_b, boundary2.ports[1]) annotation(
      Line(points = {{10, 0}, {62, 0}}, color = {0, 127, 255}));
  connect(ramp1.y, boundary1.T_in) annotation(
      Line(points = {{-100, 2}, {-84, 2}, {-84, 4}, {-82, 4}}, color = {0, 0, 127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      uses(Modelica(version="3.2.2")),
      experiment(StopTime=1000, __Dymola_NumberOfIntervals=2000),
                Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Example1;

  model Example2 "Minimalist pipe network"
    extends Modelica.Icons.Example;
    package water = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
    Modelica.Fluid.Pipes.StaticPipe pipe1(
      redeclare package Medium = water,
      length=20,
      diameter=1)
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    Modelica.Fluid.Sources.FixedBoundary boundary1(
      redeclare package Medium = water,
      nPorts=1,
      p=200000,
      T=293.15)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    Modelica.Fluid.Sources.FixedBoundary boundary2(
      redeclare package Medium = water,
      p=100000,
      T=293.15,
      nPorts= 3)
      annotation (Placement(transformation(extent={{82,-10},{62,10}})));
    Modelica.Fluid.Pipes.StaticPipe pipe2(
      redeclare package Medium = water,
      length=20,
      diameter=1) annotation (Placement(transformation(extent={{10,30},{30,50}})));
    Modelica.Fluid.Pipes.StaticPipe pipe3(
      redeclare package Medium = water,
      length=20,
      diameter=1.5)
      annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Modelica.Fluid.Pipes.StaticPipe pipe4(
  redeclare package Medium = water,
  diameter = 1, length = 20) annotation(Placement( transformation(extent = {{10, -10}, {30, 10}})));
  equation
    connect(boundary1.ports[1], pipe1.port_a)
      annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
    connect(pipe1.port_b, pipe2.port_a) annotation (Line(points={{-20,0},{0,0},{0,
            40},{10,40}}, color={0,127,255}));
    connect(pipe1.port_b, pipe3.port_a) annotation (Line(points={{-20,0},{0,0},{0,
            -40},{10,-40}}, color={0,127,255}));
    connect(pipe2.port_b, boundary2.ports[1]) annotation (Line(points={{30,40},{40,
            40},{40,2},{62,2}}, color={0,127,255}));
    connect(pipe3.port_b, boundary2.ports[2]) annotation (Line(points={{30,-40},{40,
            -40},{40,-2},{62,-2}}, color={0,127,255}));
  connect(pipe4.port_b, boundary2.ports[3]) annotation(
      Line(points = {{30, 0}, {62, 0}}, color = {0, 127, 255}));
  connect(pipe4.port_a, pipe1.port_b) annotation(
      Line(points = {{10, 0}, {-20, 0}}, color = {0, 127, 255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      uses(Modelica(version="3.2.2")),
      experiment(StopTime=100, __Dymola_NumberOfIntervals=2000),
                Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Example2;
  annotation (uses(Modelica(version="3.2.2")));
end FluidExamples;
