# Personal Training App
The mobile app is developed using the Flutter framework, an open-source framework provided by Google. This framework allows the creation of natively compiled and multi-platform applications from one codebase. In addition to using the Flutter framework, the “Personal training app” follows the BLoC (Business Logic Component) software design pattern.

### Prerequisites: 
-	Android Studio
-	Flutter
-	Physical device (iOS or Android)

### Steps:
1.	Clone git repository “PersonalTrainingApp”
2.	Open “PersonalTrainingApp” project in Android Studio
3.	Connect the mobile device via USB
4.  Since we run it on a physical device and our backend is on localhost, we need to do some extra steps to connect mobile device to the backend:
    - Connect backend machine and mobile device to same network (wifi/mobile hotspot)
    - Open this link in computer with running backend: chrome://inspect/#devices 
    - Open http://localhost:8000 in Google Chrome of device
    - Check connection of mobile device (it should have green dot next to its name)
4.	Run project on mobile device

## User Manual

1.	Sign-up<br />
  Enter following personal details:
  -	Username
  -	Email
  -	Password
  -	Confirm password
  -	Date of birth
  -	Weight (in kg)
  -	Height (in cm)
  -	Gender: Male/Female
  -	Goals
  This information will be used in suggesting the training programs.After successful sign up, you can enter your email and password and log in to the system.<br />
  ![image](https://user-images.githubusercontent.com/62064152/230714053-4ce32d48-ec95-44af-8778-c43a42d416f8.png)![image](https://user-images.githubusercontent.com/62064152/230714066-466b2d1e-f4b0-4c8e-8487-1a2117d5036a.png)


3.	Home page <br />
Home page will greet you and display Today’s session, Suggested Programs and Other Programs. You can also go to your profile by pressing the profile picture on top right corner of the page. <br />

![image](https://user-images.githubusercontent.com/62064152/230713867-6f093050-1dda-4ca6-b186-d06fa829081f.png) ![image](https://user-images.githubusercontent.com/62064152/230713997-4e15a827-2c2e-405b-a426-a9e8b3a20bf5.png)


4.	Choose program and add it <br />
Programs are suggested based on your goals (that was indicated during the sign up). There are also other programs that may be interesting for you. To see the details of the program and add it to your profile, press the program item and navigate to Program Page. <br /> 

![image](https://user-images.githubusercontent.com/62064152/230713907-1582d0cd-f92a-4bcb-8601-142474476b7c.png)

5.	See and Execute exercise in “Today’s session”<br />
After adding program, you will see the program exercises in Today’s session list. Press list item to get video and textual instruction of the exercise. After completing the exercise, you can press “Finish” button and save the training to your history.<br />

![image](https://user-images.githubusercontent.com/62064152/230713973-5976de84-631d-4658-99c4-a31e5c880a7e.png)

6.	Open camera page to do exercise counting <br />
In camera page you can forget about counting the repetitions of the exercise and focus more on the quality of your training, because special algorithm will analyze video of your training and count the repetition for you. Currently, the algorithm can count push-ups, pull-ups, and squats only. 
To start the session, choose the exercise type and record your exercise. After finishing the exercise, you will need to wait some time until system counts the repetitions. After receiving the results, you can save them into your training records.  <br />

![image](https://user-images.githubusercontent.com/62064152/230714153-a06be880-de40-4501-8ab3-5c5ab31d938a.png)
![image](https://user-images.githubusercontent.com/62064152/230714123-1a5c0689-34a0-4c28-85af-5eacf8eae475.png)
![image](https://user-images.githubusercontent.com/62064152/230714169-e48fc7ba-48a8-4eba-bdef-0831f97ea466.png)


7.	Go to Statistics page to see history and graph<br />
Statistics page will display history of your training sessions and show the weekly statistics. The graph will show daily and average training time for last week. <br />

![image](https://user-images.githubusercontent.com/62064152/230714407-25c8af03-8a18-48d3-8972-c767e2789c6e.png)
