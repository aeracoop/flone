/*
 void keyPressed() {
    // doing other things here, and then:
    if (key == CODED){
     if( keyCode == android.view.KeyEvent.KEYCODE_MENU)
        startMenu();  
  }
 }*/
 
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
    
@Override
public void onBackPressed() {
    new AlertDialog.Builder(this)
        .setIcon(android.R.drawable.ic_dialog_alert)
        .setTitle("Closing Activity")
        .setMessage("Are you sure you want to close this activity?")
        .setPositiveButton("Yes", new DialogInterface.OnClickListener()
    {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            finish();    
        }

    })
    .setNegativeButton("No", null)
    .show();
}
