This is the main Git repository for controlling the tactile motion stimulus wheel.

Structure:
+GUI/ - Includes main stimulus control GUI (does not run an experiment, only test trials)
+TestScripts/ - Includes a MATLAB script that allows you to test each motor individually 
+Arduino/ - Includes the two Arduino codes that need to be uploaded to the two Arduino boards of the stimulus setup
  - leo - controls the linear actuator that moves the stimulus along the vertical axis
  - mega - controls the large stepper motor that rotates the entire stimulus as well as the Herkulex wheel for the motion stimulus 
