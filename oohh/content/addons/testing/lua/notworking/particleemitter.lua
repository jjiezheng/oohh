util.MonitorFileInclude()

local emitter = ParticleEmitter(entities.GetLocalPlayer():GetEyePos())
emitter:SetXML[[
 <Particles Name="CXP_Waterfall.surface_wake" Id="{CCC7937E-331D-400B-B8F5-DAC897FC8ED4}" Library="Waterfall">
  <Params Enabled="false" Continuous="true" Count="10" ParticleLifeTime="1" PositionOffset=",,-0.95" EmitAngle="40.3716,1" Texture="textures/sprites/water_tiled_b.tif" TextureTiling="2,2,,4" Alpha=",,,(0.5,1;1)" Color=",,,(,(0.36,0.396,0.706);1,(1,1,1))" SoftParticle="true" DiffuseBacklighting="1" Size="2.11,0.1869919,,(;1,1)" Speed="4.91" GravityScale="0.465" RandomAngles=",180"/>
  <Childs>
   <Particles Name="foam">
    <Params Continuous="true" Count="20" ParticleLifeTime="5" PositionOffset=",-1" RandomOffset="1.5" Facing="Water" Texture="textures/sprites/waterfoam_a.tif" TextureTiling="2,2,,4" Alpha=",,,(;0.36,1;0.5,1;1)" Color="(0.62,0.61,0.57)" SoftParticle="true" DiffuseLighting="0.2" EmissiveLighting="0.5" Size="2,0.5,,(,0.6833334;1,1)" Speed="1" CameraMaxDistance="200"/>
   </Particles>
   <Particles Name="mist">
    <Params Continuous="true" Count="20,0.109" ParticleLifeTime="1.5" PositionOffset=",,1" RandomOffset="1.5" PosRandomOffset="0.5" EmitAngle=",1" Texture="textures/sprites/smoke_tiled_a.tif" TextureTiling="2,2,,4" Alpha="0.5,,,(;0.118,1,4;0.173,1,32;0.992,,4)" Color=",,,(0.004,(0.91,0.906,0.996);0.992,(0.933,0.957,0.97))" SoftParticle="true" DiffuseLighting="0.2" DiffuseBacklighting="1" EmissiveLighting="0.5" Size="2,0.228,,(,0.6416667,32;1,1,4)" Speed="0.2,0.713"/>
   </Particles>
   <Particles Name="splash">
    <Params Continuous="true" Count="125" ParticleLifeTime="2,,(,0.45416668;1,1)" PositionOffset=",,1" RandomOffset="2" EmitAngle="5,1" Texture="textures/sprites/waterfoam_a.dds" TextureTiling="2,2,,4" Alpha=",,,(;0.1,1;0.443,1;0.98,0.020833334)" Color=",,,(0.008;0.984,(1,1,1))" SoftParticle="true" DiffuseLighting="0.347" DiffuseBacklighting="1" Size="1.2,0.5,,(,,32;1,1)" Stretch="0.25,,,(;0.094;0.753,1;1,,4)" Speed="1" GravityScale="1" RandomAngles=",100" VisibleIndoors="If_False"/>
   </Particles>
  </Childs>
 </Particles>
 ]]
table.print(emitter:GetXML():explode("\n"))   
hook.Add("PostGameUpdate", "particle_test", function() emitter:EmitParticle(1) end)