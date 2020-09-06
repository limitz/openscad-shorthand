//ESP32 boards
ESP_T4   = [[40.8, 66.5, 1.25], //board
			[40.0, 55.3, 3.00], [0.4, 6.5, 0.0], //SCREEN OFFSET
			[6, 7.4, 3], [-1.5, 36.5, -4.25], //connector
			[ //buttons
				[[6.5,3.8, 1.5],[ 7.7, 0.0, 0.0],[1.5,1,1.5],[ 3.5,1.5,0.7]],
				[[6.5,3.8, 1.5],[17.7, 0.0, 0.0],[1.5,1,1.5],[ 3.5,1.5,0.7]],
				[[6.5,3.8, 1.5],[28.5, 0.0, 0.0],[1.5,1,1.5],[ 3.5,1.5,0.7]],
				[[3.0,5.0, 3.0],[ 0.0,56.0,-3.0],[2.0,1,0.5],[-2.0,1.5,1.0]],
			],
			[ //keep clear
			 [[34, 45, 10], [3.4, 14, 0.0]],
            [[41.8, 67.5, 4],[-0.5, -0.5, -2]]
             
			]
		];
ESP_TTGO = [[25.2, 51.2, 1.22],  //board
            [18.6, 32.0, 1.6], [3.3, 12.0, 2.0], //screen, offset
            [9, 7.4, 3.2], [8.0, -1.5, 0.15], //connector
            [ // buttons
                [[3.5, 4.3, 2.0], [ 2.5, 1.0, 0.0], [0.5, 0.5, 2.0], [2.5, 3.3, 0.5]],
                [[3.5, 4.3, 2.0], [18.5, 1.0, 0.0], [0.5, 0.5, 2.0], [2.5, 3.3, 0.5]],
                [[2.2, 4.8, 1.8], [22.7, 9.5, 0.0], [2.2, 1.4, 0.4], [2.0, 2.0, 1.0]]
            ],
            [ //keep clear
                [[23.6, 48.0, 8.0], [0.8, -1.0, -5.0]],
                [[16.6, 27.0, 4.0], [4.3, 16, 3.0]]
            ],
            
           ]; 

module battery(size=[30.6, 50, 6.6])
{
    color("#888800")
    cube(size, center=true);
}

module esp(type, show_clearance)
{
    translate([-type[0][0]/2, -type[0][1]/2, 0])
    {
        //board
        color("#111111")
        translate([0,0,-type[0][2]])
        cube(type[0]);
        
        //screen
        color("#AAAACCAA")
        translate(type[2]) cube(type[1]);

        // connector
        color("silver")
        hull() {
            translate(type[4]+[0.3, 0, 0]) cube(type[3]-[0.6, 0.0, 0.0]);
            translate(type[4]+[0.0, 0, 0.3]) cube(type[3]-[0.0, 0.0, 0.6]);
        }
        color("#FF8800")
        hull() {
            translate(type[4]+[-1, 0.4, 0.1]) cube(type[3]-[0.2, 0.8, 0.2]);
            translate(type[4]+[-1, 0.1, 0.4]) cube(type[3]-[0.2, 0.2, 0.8]);
        }
        
        for (button = type[5])
        {
            color("#DDDDDD")
            translate(button[1])
            cube(button[0]);
            
            color("#99FF00")
            translate(button[1] + button[2])
            cube(button[3]);
        }
        if (show_clearance)
        difference()
        {
            color("#FF000033")
            union() for (clear = type[6])
            translate(clear[1])
            cube(clear[0]);
        
            union() for (button = type[5])
            translate(button[1] + button[2])
            cube(button[3] + 5 * [for (a = [0:2]) button[2][a]-button[0][a] ? 0 : 1]);
                
        }
    }
}

module shape(size)
{
    hull()
    {
        translate([0,0,-8])
        cube(size + [-4,-1,0], center = true);
        
        translate([0,0,-5])
        cube(size + [-6, 6, 0],center=true);     
    }
}
difference()
{
    translate([0,0,6.6]) shape([50,70,2]);
    translate([0,0,-1.55])
    {
        scale(1) esp(ESP_T4, true);
        //translate([0,0,-8])
        //battery();
    }
}