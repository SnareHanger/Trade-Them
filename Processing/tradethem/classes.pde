class Assets {
  String handle;
  float company1;
  float company2;
  float company3;
  float company4;
  float cash;

  public Assets( String[] pieces ) {
    handle = pieces[0];
    company1 = float( pieces[1] );
    company2 = float( pieces[2] );
    company3 = float( pieces[3] );
    cash = float( pieces[4] );
  }
}


class Prices{
  float company1;
  float company2;
  float company3;
  float company4;

  public Prices( String[] pieces ) {
    company1 = float( pieces[0] );
    company2 = float( pieces[1] );
    company3 = float( pieces[2] );
    company4 = float( pieces[3] );
  }
}

