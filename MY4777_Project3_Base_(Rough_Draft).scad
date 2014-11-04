module cutout1 () {

hull () {

translate ([0,2.5,-.1]) cube ([30,7, 2.75], center = false);
translate ([0,7,-.1]) cylinder (h = 2.75, r = 4.5, center = false);
translate ([30,7,-.1]) cylinder (h = 2.75, r = 4.5, center = false);

}

hull () {

translate ([0,55.14,-.1]) cube ([30,7, 2.75], center = false);
translate ([0,59.64,-.1]) cylinder (h = 2.75, r =4.5, center = false);
translate ([30,59.64,-.1]) cylinder (h = 2.75, r =4.5, center = false);

}

hull () {

translate ([0,2.5,5]) cube ([30,8, 7.26], center = false);
translate ([0,7,5]) cylinder (h = 7.26, r = 5, center = false);
translate ([30,7,5]) cylinder (h = 7.26, r = 5, center = false);

}

hull () {

translate ([0,55.14,5]) cube ([30, 8, 7.26], center = false);
translate ([0,59.64,5]) cylinder (h = 7.26, r = 5, center = false);
translate ([30,59.64,5]) cylinder (h = 7.26, r = 5, center = false);

}

}

module cutout2 () {

union () {

cutout1 ();


hull () {

translate ([0,3.5,0]) cube ([30,7, 12.25], center = false);
translate ([0,7,0]) cylinder (h = 12.25, r = 3.5, center = false);
translate ([30,7,0]) cylinder (h = 12.25, r = 3.5, center = false);

}

hull () {

translate ([0,56.14,0]) cube ([30,7, 12.25], center = false);
translate ([0,59.64,0]) cylinder (h = 12.25, r =3.5, center = false);
translate ([30,59.64,0]) cylinder (h = 12.25, r =3.5, center = false);

}

}

}

module base () {

difference () {

translate ([-6.5,66.64,0]) rotate ([0,0,-90]) cube ([66.64, 43.27, 12.25], center = false);

cutout2();

}

}

/////

module gear_holder () {

difference () {

translate ([0,22.5,-0.1]) { 

rotate([0, 270, 0]) {

cube ([15,25,25], center = true);

}

}

cube ([15, 15, 60.0], center = true);

}

}

module main_base () {

difference () {

cube ([25, 25, 50.75], center = true);

translate ([0,0,-0.1]) { 

cube ([15, 15, 60.0], center = true);

}

}

}

module quarter_final_base () {

union () {

main_base ();

gear_holder ();

}

}


module semi_final_base () {

difference () {

quarter_final_base ();

translate ([0,20,0]) {

cube ([15, 40, 20], center = true);

}

}



}

module final_base () {

difference () {

semi_final_base ();

translate ([0,18,-0.1]) { 

rotate([0, 90, 0]) {

cube ([3,25,50], center = true);

//cylinder (r = 1.5, h= 27, center = true);

}

}

}

}

module Project_3 () {

union () {

translate ([6,33.32,37.625]) {

rotate ([0,0,270]){

final_base ();

}

}

base ();

}

}

Project_3 ();
