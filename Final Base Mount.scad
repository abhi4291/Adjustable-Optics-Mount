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

translate ([-8.5,68.64,0]) rotate ([0,0,-90]) cube ([70.64, 47.27, 12.25], center = false);
cutout2();

}

}



module final_base () {

difference () {

union(){

cube ([25, 25, 50.75], center = true);
translate ([12.5,12.5,-0.1])rotate([0, 270, 0])
linear_extrude(height = 25) polygon(points=[[0,-10],[25.475,-10],[25.475,7.5],[16,7.5],[8.5,0]], convexity = 10);


}

translate ([0,-7.5+22,20])rotate([0, 90, 0])cylinder (r = 2, h= 27, center = true, $fn=20);
translate ([0,11.5,0])cube ([14.5, 40, 80], center = true);
}
}



module Project_3 () {


union () {

translate ([4,33.32,37.625])rotate ([0,0,270])final_base();
base ();

}

}

Project_3 ();
