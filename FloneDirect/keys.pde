
 void keyPressed() {
    // doing other things here, and then:
    if (key == CODED){
     if( keyCode == android.view.KeyEvent.KEYCODE_MENU)
        startMenu();  
  }
 }
 
 /*
 public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
            case R.id.new_game:
                newGame();
                return true;
            case R.id.help:
                showHelp();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }*/
