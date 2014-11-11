//////////////////////////////////////////////////////////////////////////////////////////////
// Public Domain Parametric Involute Spur Gear (and involute helical gear and involute rack)
// version 1.1
// by Leemon Baird, 2011, Leemon@Leemon.com
//http://www.thingiverse.com/thing:5505
//
// This file is public domain.  Use it for any purpose, including commercial
// applications.  Attribution would be nice, but is not required.  There is
// no warranty of any kind, including its correctness, usefulness, or safety.
// 
// This is parameterized involute spur (or helical) gear.  It is much simpler and less powerful than
// others on Thingiverse.  But it is public domain.  I implemented it from scratch from the 
// descriptions and equations on Wikipedia and the web, using Mathematica for calculations and testing,
// and I now release it into the public domain.
//
//		http://en.wikipedia.org/wiki/Involute_gear
//		http://en.wikipedia.org/wiki/Gear
//		http://en.wikipedia.org/wiki/List_of_gear_nomenclature
//		http://gtrebaol.free.fr/doc/catia/spur_gear.html
//		http://www.cs.cmu.edu/~rapidproto/mechanisms/chpt7.html
//
// The module gear() gives an involute spur gear, with reasonable defaults for all the parameters.
// Normally, you should just choose the first 4 parameters, and let the rest be default values.
// The module gear() gives a gear in the XY plane, centered on the origin, with one tooth centered on
// the positive Y axis.  The various functions below it take the same parameters, and return various
// measurements for the gear.  The most important is pitch_radius, which tells how far apart to space
// gears that are meshing, and adendum_radius, which gives the size of the region filled by the gear.
// A gear has a "pitch circle", which is an invisible circle that cuts through the middle of each
// tooth (though not the exact center). In order for two gears to mesh, their pitch circles should 
// just touch.  So the distance between their centers should be pitch_radius() for one, plus pitch_radius() 
// for the other, which gives the radii of their pitch circles.
//
// In order for two gears to mesh, they must have the same mm_per_tooth and pressure_angle parameters.  
// mm_per_tooth gives the number of millimeters of arc around the pitch circle covered by one tooth and one
// space between teeth.  The pitch angle controls how flat or bulged the sides of the teeth are.  Common
// values include 14.5 degrees and 20 degrees, and occasionally 25.  Though I've seen 28 recommended for
// plastic gears. Larger numbers bulge out more, giving stronger teeth, so 28 degrees is the default here.
//
// The ratio of number_of_teeth for two meshing gears gives how many times one will make a full 
// revolution when the the other makes one full revolution.  If the two numbers are coprime (i.e. 
// are not both divisible by the same number greater than 1), then every tooth on one gear
// will meet every tooth on the other, for more even wear.  So coprime numbers of teeth are good.
//
// The module rack() gives a rack, which is a bar with teeth.  A rack can mesh with any
// gear that has the same mm_per_tooth and pressure_angle.
//
// Some terminology: 
// The outline of a gear is a smooth circle (the "pitch circle") which has mountains and valleys
// added so it is toothed.  So there is an inner circle (the "root circle") that touches the 
// base of all the teeth, an outer circle that touches the tips of all the teeth,
// and the invisible pitch circle in between them.  There is also a "base circle", which can be smaller than
// all three of the others, which controls the shape of the teeth.  The side of each tooth lies on the path 
// that the end of a string would follow if it were wrapped tightly around the base circle, then slowly unwound.  
// That shape is an "involute", which gives this type of gear its name.
//
//////////////////////////////////////////////////////////////////////////////////////////////

//An involute spur gear, with reasonable defaults for all the parameters.
//Normally, you should just choose the first 4 parameters, and let the rest be default values.
//Meshing gears must match in mm_per_tooth, pressure_angle, and twist,
//and be separated by the sum of their pitch radii, which can be found with pitch_radius().
module gear (
	mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
	number_of_teeth = 11,   //total number of teeth around the entire perimeter
	thickness       = 6,    //thickness of gear in mm
	hole_diameter   = 3,    //diameter of the hole in the center, in mm
	twist           = 0,    //teeth rotate this many degrees from bottom of gear to top.  360 makes the gear a screw with each thread going around once
	teeth_to_hide   = 0,    //number of teeth to delete to make this only a fraction of a circle
	pressure_angle  = 28,   //Controls how straight or bulged the tooth sides are. In degrees.
	clearance       = 0.0,  //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
	backlash        = 0.0   //gap between two meshing teeth, in the direction along the circumference of the pitch circle
) {
	assign(pi = 3.1415926)
	assign(p  = mm_per_tooth * number_of_teeth / pi / 2)  //radius of pitch circle
	assign(c  = p + mm_per_tooth / pi - clearance)        //radius of outer circle
	assign(b  = p*cos(pressure_angle))                    //radius of base circle
	assign(r  = p-(c-p)-clearance)                        //radius of root circle
	assign(t  = mm_per_tooth/2-backlash/2)                //tooth thickness at pitch circle
	assign(k  = -iang(b, p) - t/2/p/pi*180) {             //angle to where involute meets base circle on each side of tooth
		difference() {
			for (i = [0:number_of_teeth-teeth_to_hide-1] )
				rotate([0,0,i*360/number_of_teeth])
					linear_extrude(height = thickness, center = true, convexity = 10, twist = twist)
						polygon(
							points=[
								[0, -hole_diameter/10],
								polar(r, -181/number_of_teeth),
								polar(r, r<b ? k : -180/number_of_teeth),
								q7(0/5,r,b,c,k, 1),q7(1/5,r,b,c,k, 1),q7(2/5,r,b,c,k, 1),q7(3/5,r,b,c,k, 1),q7(4/5,r,b,c,k, 1),q7(5/5,r,b,c,k, 1),
								q7(5/5,r,b,c,k,-1),q7(4/5,r,b,c,k,-1),q7(3/5,r,b,c,k,-1),q7(2/5,r,b,c,k,-1),q7(1/5,r,b,c,k,-1),q7(0/5,r,b,c,k,-1),
								polar(r, r<b ? -k : 180/number_of_teeth),
								polar(r, 181/number_of_teeth)
							],
 							paths=[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]]
						);
			cylinder(h=2*thickness+1, r=hole_diameter/2, center=true, $fn=20);
		}
	}
};	
//these 4 functions are used by gear
function polar(r,theta)   = r*[sin(theta), cos(theta)];                            //convert polar to cartesian coordinates
function iang(r1,r2)      = sqrt((r2/r1)*(r2/r1) - 1)/3.1415926*180 - acos(r1/r2); //unwind a string this many degrees to go from radius r1 to radius r2
function q7(f,r,b,r2,t,s) = q6(b,s,t,(1-f)*max(b,r)+f*r2);                         //radius a fraction f up the curved side of the tooth 
function q6(b,s,t,d)      = polar(d,s*(iang(b,d)+t));                              //point at radius d on the involute curve

//a rack, which is a straight line with teeth (the same as a segment from a giant gear with a huge number of teeth).
//The "pitch circle" is a line along the X axis.
module rack (
	mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
	number_of_teeth = 11,   //total number of teeth along the rack
	thickness       = 6,    //thickness of rack in mm (affects each tooth)
	height          = 120,   //height of rack in mm, from tooth top to far side of rack.
	pressure_angle  = 28,   //Controls how straight or bulged the tooth sides are. In degrees.
	backlash        = 0.0   //gap between two meshing teeth, in the direction along the circumference of the pitch circle
) {
	assign(pi = 3.1415926)
	assign(a = mm_per_tooth / pi) //addendum
	assign(t = a*cos(pressure_angle)-1)         //tooth side is tilted so top/bottom corners move this amount
		for (i = [0:number_of_teeth-1] )
			translate([i*mm_per_tooth,0,0])
				linear_extrude(height = thickness, center = true, convexity = 10)
					polygon(
						points=[
							[-mm_per_tooth * 3/4,                 a-height],
							[-mm_per_tooth * 3/4 - backlash,     -a],
							[-mm_per_tooth * 1/4 + backlash - t, -a],
							[-mm_per_tooth * 1/4 + backlash + t,  a],
							[ mm_per_tooth * 1/4 - backlash - t,  a],
							[ mm_per_tooth * 1/4 - backlash + t, -a],
							[ mm_per_tooth * 3/4 + backlash,     -a],
							[ mm_per_tooth * 3/4,                 a-height],
						],
						paths=[[0,1,2,3,4,5,6,7]]
					);
};	

//These 5 functions let the user find the derived dimensions of the gear.
//A gear fits within a circle of radius outer_radius, and two gears should have
//their centers separated by the sum of their pictch_radius.
function circular_pitch  (mm_per_tooth=3) = mm_per_tooth;                     //tooth density expressed as "circular pitch" in millimeters
function diametral_pitch (mm_per_tooth=3) = 3.1415926 / mm_per_tooth;         //tooth density expressed as "diametral pitch" in teeth per millimeter
function module_value    (mm_per_tooth=3) = mm_per_tooth / pi;                //tooth density expressed as "module" or "modulus" in millimeters
function pitch_radius    (mm_per_tooth=3,number_of_teeth=11) = mm_per_tooth * number_of_teeth / 3.1415926 / 2;
function outer_radius    (mm_per_tooth=3,number_of_teeth=11,clearance=0.1)    //The gear fits entirely within a cylinder of this radius.
	= mm_per_tooth*(1+number_of_teeth/2)/3.1415926  - clearance;              

//////////////////////////////////////////////////////////////////////////////////////////////
//example gear train.  
//Try it with OpenSCAD View/Animate command with 20 steps and 24 FPS.
//The gears will continue to be rotated to mesh correctly if you change the number of teeth.

n1 = 11; //red gear number of teeth
n2 = 20; //green gear
n3 = 5;  //blue gear
n4 = 20; //orange gear
n5 = 11;  //gray rack
mm_per_tooth = 5; //all meshing gears need the same mm_per_tooth (and the same pressure_angle)
thickness    = 14;
hole         = 4;
height       = 15;

d1 =pitch_radius(mm_per_tooth,n1);
d12=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n2);
d13=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n3);
d14=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n4);

//translate([0,0,0]) rotate([0,0, $t*360/n1])color([1.00,0.75,0.75])
//gear(mm_per_tooth,n1,thickness,hole);

translate([(-floor(n5/2)-floor(n1/2)+$t+n1/2-1/2)*9+20, -d1-10.0, 0]) rotate([0,0,0]) color([0.75,0.75,0.75]){
union(){
rack(mm_per_tooth,n5,thickness,height);

translate([-3,-13.408005,-7]) rotate([0,270,0])
cube([14,11.8165,30]);

translate([-47,-7.5,-7])lens_holder();

translate([58,-13.408005,-7]) rotate([0,270,0])
cube([14,15,8]);

}
}


x=25.4; //Diameter of the Lens
y=10;   //Lens holder Thickness
z=3;     //Lens Holder Lip Size
X=25; //Base Diameter
Y=25;  //Base Height
a=3; //Set Screw Diameter
b=6; //Set Screw Nut Daimeter
c=3; //Set Screw Nut Thickness
d=8; //Guide Rod Diameter
e=20; //Guide Rod Length
f=3;    // Thumb Screw Head Height
g=6;   //Thumb Screw Head Diameter
i=3;    //Thumb Screw Diameter
j=3;    //PL Board Hole Diameter


module thumbscrew(){
difference(){
cylinder(f+2,(g+6)/2, (g+6)/2);
translate([0,0,2])cylinder(5,(g+1)/2, (g+1)/2);
cylinder(5,(i+1)/2, (i+1)/2);
}
difference(){
	for ( i = [0 :8] ){
					rotate( i * 360 / 8, [0, 0, 1])
					translate([(g+6)/2,0,0])
					cylinder(5,3,3);
		}	
translate([0,0,2])cylinder(5,(g+1)/2, (g+1)/2);
}
}

module mount(){
difference(){
cylinder((2/5)*Y,X/2,X/2);
translate([0,0,(1/5)*Y])cylinder(Y,(d+1)/2,(d+1)/2);
}
difference(){
translate([0,0,(2/5)*Y])cylinder((2/5)*Y,X/2,(d+6)/2);
cylinder(Y,(d+1)/2,(d+1)/2);

}
difference(){
translate([0,0,(4/5)*Y])cylinder((1/5)*Y,(d+6)/2,(d+6)/2);
cylinder(Y,(d+1)/2,(d+1)/2);

}
difference(){
translate([0,(X/2)+3,0])cylinder(5,(j+6)/2, (j+6)/2);
translate([0,(X/2)+3,0])cylinder(5,(j+1)/2, (j+1)/2);
}
difference(){
translate([0,(X/2)-2,5/2])cube([j+6,j+6,5],center = true);
translate([0,(X/2)+3,0])cylinder(5,(j+1)/2, (j+1)/2);
}
}

module lens_holder(){
difference(){
cylinder(y/2,(x+10)/2,(x+10)/2);
cylinder((y+2)/2,(x-3)/2,(x-3)/2);
translate([0,0,1.5])cylinder((y+2)/2,(x+1)/2,(x+1)/2);
translate([0,(x+10)/2+5,(b+3)/2])rotate([90,0,0])cylinder(10,(a+1)/2,(a+1)/2);
translate([0,(x+8)/2,(b+3)/2])nuttrap();
//translate([(x+15)/2,e/2,(d+6)/2])%rotate([90,0,0])cylinder(e,(d+6)/2, (d+6)/2);
}
difference(){
translate([0,0,y/2])cylinder((y)/2,(x+5)/2,(x+5)/2);
cylinder((y)*2,(x+1)/2,(x+1)/2);
translate([0,(x+10)/2+5,(b+3)/2])rotate([90,0,0])cylinder(25,(b+3)/2,(b+3)/2);
translate([0,(x+8)/2,(b+3)/2])nuttrap();
}
difference(){
translate([0,(x+8)/2,0])set_screw((b+3)/2);
cylinder((y+2),(x+1)/2,(x+1)/2);
}
//difference(){
//translate([(x+15)/2,0,0])guide_rod();
//rotate([0,0,90]){
//#translate([0,((x+7)/-2)-((d)),(d+6)/2])rotate([90,0,0])cylinder(50,(a+1)/2,(a+1)/2);
//translate([((x+7.5)/2)+((d+6)),0,0])rotate([0,0,90])set_screw1((d+6)/2);
//}
//}
//translate([((x+7.5)/2)+((d+6)),0,0])rotate([0,0,90])set_screw((d+6)/2);
}

module guide_rod(){
difference(){
translate([0,e/2,(d+6)/2])rotate([90,0,0])cylinder(e,(d+6)/2, (d+6)/2);
translate([0,(e/2)+1,(d+6)/2])rotate([90,0,0])cylinder(e+2,(d+1)/2, (d+1)/2);
}
difference(){
translate([0,0,(d+6)/4])cube([(d+6),e,(d+6)/2], center = true);
translate([0,(e/2)+1,(d+6)/2])rotate([90,0,0])cylinder(e+2,(d+1)/2, (d+1)/2);
}
}

module set_screw(h){
difference(){
translate([0,5,h])rotate([90,0,0])cylinder(10,(b+3)/2, (b+3)/2);
translate([0,10,h])rotate([90,0,0])cylinder(200,(a+1)/2, (a+1)/2);
translate([0,0,h])nuttrap();
}
difference(){
translate([0,0,h/2])cube([(b+3),10,h], center = true);
translate([0,6,h])rotate([90,0,0])cylinder(12,(a+1)/2, (a+1)/2);
translate([0,0,h])nuttrap();
}
}
module set_screw1(h){
translate([0,5,h])rotate([90,0,0])cylinder(10,(b+3)/2, (b+3)/2);
translate([0,0,h/2])cube([(b+3),10,h], center = true);

}



module nuttrap(){
translate([0,(c+1)/2,0])rotate([90,0,0])hexagon(c+1,(b+1)/2);
translate([0,0,(b*3)/2])cube([b+1,c+1,b*3],center = true);
}

module reg_polygon(sides,radius)
{
  function dia(r) = sqrt(pow(r*2,2)/2);  //sqrt((r*2^2)/2) if only we had an exponention op
  if(sides<2) square([radius,0]);
  if(sides==3) triangle(radius);
  if(sides==4) square([dia(radius),dia(radius)],center=true);
  if(sides>4) circle(r=radius,$fn=sides);
}

module hexagonf(radius)
{
  reg_polygon(6,radius);
}

module hexagon(height,radius) 
{
  linear_extrude(height=height) hexagonf(radius);
}
