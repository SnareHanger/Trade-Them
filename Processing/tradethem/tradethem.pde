String[] inFile;
PFont gothic, calibri, gothicBig;
PImage rightNow;

Assets[] assets;
Prices[] prices;
String[] companies;

void setup() {
  size( screen.width, screen.height );
  smooth();

  rightNow = loadImage( "photo.jpg" );

  gothic = loadFont( "gothic.vlw" );
  calibri = loadFont( "calibri.vlw" );
  gothicBig = loadFont( "gothic-52.vlw" );


  inFile = loadStrings( "assets.csv" );
  assets = new Assets[inFile.length - 1];
  for( int i = 1; i < inFile.length; i++ ) {
    String[] pieces = inFile[i].split( "," );
    assets[i-1] = new Assets( pieces );
  }

  inFile = loadStrings( "stockprices.csv" );
  prices = new Prices[inFile.length - 1];
  companies = new String[4];
  companies = inFile[0].split(",");
  println(companies);
  for( int i = 1; i < inFile.length; i++) {
    String[] pieces = inFile[i].split( "," );
    prices[i-1] = new Prices( pieces );
  }
}

void draw() {
  background( 255 );
  noStroke();
  fill( 30, 30, 30 );
  rect( 0, 0, screen.width, screen.height/2 );

  noStroke();
  fill( 0, 0, 0 );
  rect( 0, screen.height/2, screen.width, screen.height/2 );

  noStroke();
  fill( 80, 80, 80 );
  rect( screen.width/2, 0, screen.width/2, screen.height );

  stroke( 255 );
  strokeWeight( 2 );
  line( screen.width / 2, 0, screen.width / 2, screen.height );



  int stretch = 40;
  int shift = 120;
  int topPrice = 190;
  int bottomPrice = 50;

  pushMatrix();
  translate( 30, 0 );

  stroke(255);
  line( shift, screen.height/2 - 70, 14 * stretch + shift, screen.height/2 - 70 );

  for( int i = 0; i < 215; i+=3 ) {
    strokeWeight( 1 );
    line( shift, 100 + i * 2, shift, 102 + i * 2 );

    strokeWeight( 1 );
    line( 14 * stretch + shift, 100 + i * 2, 14 * stretch + shift, 102 + i * 2 );
  } 

  strokeWeight( 3 );
  beginShape();
  curveVertex( 0 * stretch + shift, map( prices[0].company1, bottomPrice, topPrice, screen.height/2, 0 ) );   
  for( int i = 0; i < prices.length; i++ ) {
    //company 1
    stroke( 255, 255, 0 ); 
    noFill();
    curveVertex( i * stretch + shift, map( prices[i].company1, bottomPrice, topPrice, screen.height/2, 0 ) );   
//    line( (i-1) * stretch + shift, map( prices[i-1].company1, bottomPrice, topPrice, 0, screen.height/2 ), 
//    i *stretch + shift, map( prices[i].company1, bottomPrice, topPrice, 0, screen.height/2 ) );
  }
  curveVertex( (prices.length) * stretch + shift, map( prices[prices.length-1].company1, bottomPrice, topPrice, screen.height/2, 0 ) );   
  endShape();


  beginShape();
  curveVertex( 0 * stretch + shift, map( prices[0].company2, bottomPrice, topPrice, screen.height/2, 0 ) );
  curveVertex( 0 * stretch + shift, map( prices[0].company2, bottomPrice, topPrice, screen.height/2, 0 ) );
  for( int i = 1; i < prices.length; i++ ) {
    //company 2
    stroke( 0, 255, 255 ); 
    curveVertex( i * stretch + shift, map( prices[i].company2, bottomPrice, topPrice, screen.height/2, 0 ) );   
  }
  curveVertex( (prices.length) * stretch + shift, map( prices[prices.length-1].company2, bottomPrice, topPrice, screen.height/2, 0 ) );   
  endShape();

  beginShape();
  curveVertex( 0 * stretch + shift, map( prices[0].company3, bottomPrice, topPrice, screen.height/2, 0 ) ); 
  curveVertex( 0 * stretch + shift, map( prices[0].company3, bottomPrice, topPrice, screen.height/2, 0 ) );
  for( int i = 1; i < prices.length; i++ ) { 
    //company 3
    stroke( 255, 0, 255 ); 
    curveVertex( i * stretch + shift, map( prices[i].company3, bottomPrice, topPrice, screen.height/2, 0 ) );   
  }
  curveVertex( (prices.length) * stretch + shift, map( prices[prices.length-1].company3, bottomPrice, topPrice, screen.height/2, 0 ) );   
  endShape(); 

  beginShape();
  curveVertex( 0 * stretch + shift, map( prices[0].company4, bottomPrice, topPrice, screen.height/2, 0 ) );
  curveVertex( 0 * stretch + shift, map( prices[0].company4, bottomPrice, topPrice, screen.height/2, 0 ) );
  for( int i = 1; i < prices.length; i++ ) {
    //company 4
    stroke( 0, 255, 0 ); 
    curveVertex( i * stretch + shift, map( prices[i].company4, bottomPrice, topPrice, screen.height/2, 0 ) );   
  }
  curveVertex( (prices.length) * stretch + shift, map( prices[prices.length-1].company4, bottomPrice, topPrice, screen.height/2, 0 ) );   
  endShape();  
  


  textFont( gothic );
  textAlign( LEFT );
  fill( 255, 255, 0 );
  text( companies[0], prices.length * stretch + shift + 60, map( prices[ prices.length - 1 ].company1, bottomPrice, topPrice, screen.height/2, 0 ) + 8 );

  fill( 0, 255, 255 );
  text( companies[1], prices.length * stretch + shift + 60, map( prices[ prices.length - 1 ].company2, bottomPrice, topPrice, screen.height/2, 0 ) + 8 );

  fill( 255, 0, 255 );
  text( companies[2], prices.length * stretch + shift + 60, map( prices[ prices.length - 1 ].company3, bottomPrice, topPrice, screen.height/2, 0 ) + 8 );

  fill( 0, 255, 0 );
  text( companies[3], prices.length * stretch + shift + 60, map( prices[ prices.length - 1 ].company4, bottomPrice, topPrice, screen.height/2, 0 ) + 8 );  

  //Stock Prices
  textFont( calibri );
  textAlign( RIGHT );
  fill( 255, 255, 0 );
  text( prices[0].company1, 0 * stretch + shift - 10, map( prices[ 0 ].company1, bottomPrice, topPrice, screen.height/2, 0 ) + 5 );

  fill( 0, 255, 255 );
  text( prices[0].company2, 0 * stretch + shift - 10, map( prices[ 0 ].company2, bottomPrice, topPrice, screen.height/2, 0 ) + 5 );

  fill( 255, 0, 255 );
  text( prices[0].company3, 0 * stretch + shift - 10, map( prices[ 0 ].company3, bottomPrice, topPrice, screen.height/2, 0 ) + 5 );

  fill( 0, 255, 0 );
  text( prices[0].company4, 0 * stretch + shift - 10, map( prices[ 0 ].company4, bottomPrice, topPrice, screen.height/2, 0 ) + 5 );


  textAlign( LEFT );
  fill( 255, 255, 0 );
  text( prices[prices.length - 1].company1, ( prices.length - 1 ) * stretch + shift + 10, map( prices[ prices.length - 1 ].company1, bottomPrice, topPrice, screen.height/2, 0 ) + 5 );

  fill( 0, 255, 255 );
  text( prices[prices.length - 1].company2, ( prices.length - 1 ) * stretch + shift + 10, map( prices[ prices.length - 1 ].company2, bottomPrice, topPrice, screen.height/2, 0 ) + 5 );

  fill( 255, 0, 255 );
  text( prices[prices.length - 1].company3, ( prices.length - 1 ) * stretch + shift + 10, map( prices[ prices.length - 1 ].company3, bottomPrice, topPrice, screen.height/2, 0 ) + 5 );

  fill( 0, 255, 0 );
  text( prices[prices.length - 1].company4, ( prices.length - 1 ) * stretch + shift + 10, map( prices[ prices.length - 1].company4, bottomPrice, topPrice, screen.height/2, 0 ) + 5 );  

  popMatrix();

  //IMAGE
  fill( 255, 255, 255 );
  noStroke();
  rect( shift + 10, screen.height / 2 + 50, rightNow.width + 20, rightNow.height + 20 );
  image( rightNow, shift + 20, screen.height / 2 + 60 );


  //LEADER BOARD
  pushMatrix();
  translate( 10, 65 );

  fill( 255 );
  textFont( gothicBig );
  textAlign( CENTER );
  text( "TRADE THEM", screen.width * 3 / 4 + 18, 50 );


  for( int i = 0; i < assets.length; i++ ) {
    noStroke();
    fill( 139, 149, 250 );
    rect( screen.width / 2 + 70, shift + i * 60 - 34, screen.width / 2 - shift - 30, 50 );

    fill( 30 );
    rect( screen.width / 2 + 130, shift + i * 60 - 34, 200, 50 );

    fill( 30 );
    rect( screen.width / 2 + 650, shift + i * 60 - 34, 178, 50 );
  }

  for( int i = 0; i < assets.length; i+=2 ) {
    noStroke();
    fill( 189, 199, 250 );
    rect( screen.width / 2 + 70, shift + i * 60 - 34, screen.width / 2 - shift - 30, 50 );

    fill( 30 );
    rect( screen.width / 2 + 130, shift + i * 60 - 34, 200, 50 );

    fill( 30 );
    rect( screen.width / 2 + 650, shift + i * 60 - 34, 178, 50 );
  }

  for( int i = 0; i < 4; i++ ) {
    textFont( gothic );
    textAlign( CENTER );
    fill( 255, 255, 0 );
    text( companies[0] + "  $" + nfc( prices[prices.length - 1].company1, 0 ), screen.width / 2 + shift * 2 - 10, shift + i * 60 );
  }

  for( int i = 4; i < 8; i++ ) {
    textFont( gothic );
    textAlign( CENTER );
    fill( 0, 255, 255 );
    text( companies[1] + "  $" + nfc( prices[prices.length - 1].company2, 0 ), screen.width / 2 + shift * 2 - 10, shift + i * 60 );
  }

  for( int i = 8; i < 12; i++ ) {
    textFont( gothic );
    textAlign( CENTER );
    fill( 255, 0, 255 );
    text( companies[2] + "  $" + nfc( prices[prices.length - 1].company3, 0 ), screen.width / 2 + shift * 2 - 10, shift + i * 60 );
  }

  for( int i = 12; i < 16; i++ ) {
    textFont( gothic );
    textAlign( CENTER );
    fill( 0, 255, 0 );
    text( companies[3] + "  $" + nfc( prices[prices.length - 1].company4, 0 ), screen.width / 2 + shift * 2 - 10, shift + i * 60 );
  }

  for( int i = 0; i < assets.length; i++ ) {
    textFont( gothic );
    textAlign( CENTER );
    fill( 0 );
    text( assets[i].handle, screen.width / 2 + shift * 2 + 248, shift + i * 60 );

    fill( 255 );
    float netWorth = 
      assets[i].company1 * prices[prices.length-1].company1 + 
      assets[i].company2 * prices[prices.length-1].company2 + 
      assets[i].company3 * prices[prices.length-1].company3 + 
      assets[i].company4 * prices[prices.length-1].company4 + 
      assets[i].cash;
      
    text( "$" + nfc( netWorth, 0 ), screen.width / 2 + shift * 2 + 500, shift + i * 60 );
  }

  popMatrix();
}

