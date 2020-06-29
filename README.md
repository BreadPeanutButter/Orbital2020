***NUS WhatToDo***

**Team**

Heng Yong Ming

Lee Joon Jie

**Download and Install NUS WhatToDo**

Latest Version: v1.0

Link: [https://github.com/hengyongming/Orbital2020/releases](https://github.com/hengyongming/Orbital2020/releases)

1. Download the apk file from the link and follow on-screen instructions to install on Android

2. Create an account by signing up

3. Explore the app!

**Motivation**

We realised that in NUS, there isn't a centralised and portable online platform for students to obtain information regarding a particular CCA that he/she is interested in other than the official NUS website. However, the NUS website provides minimal information and is not maintained by the CCAs themselves. This has limited utility to people looking for more detailed and up-to-date information. Most CCAs have their own social media pages but this is not central and may lack outreach.

**Aim**

We hope to make information and updates regarding CCAs more central and accessible to NUS students with an app. We also hope that the information that students obtain is reliable and updated.

**Concept Validation**

Our app is a centralised mobile (and hence portable) platform for CCAs to disseminate first-hand information about themselves and for students to benefit from that information conveniently. We believe there is no such app as of yet though here are several similar alternatives.

**NUS Student Organisations Directory:** The NUS SOD is the official directory for all of NUS&#39;s CCAs. However as mentioned above, it is not maintained by CCAs themselves. It is also not commonly used by students and has limited impact.

**NUS Sync:** NUS Sync is similar to our app in that it is maintained by CCAs. CCAs are also able to post events on there to publicise. However, it is a website and does not have a mobile(portable) app. We aim to create something that is similar to NUS Sync but optimised for mobile usage at the same time. This is so that students can obtain CCA information quickly and conveniently on the go.

**Social Media &amp; Other Forms of Communication:** Most CCAs already have their own channels of disseminating information such as Telegram, Instagram, Facebook etc. However, this is not centralised and only useful for students who already know the CCA. For new students still unfamiliar with the school, it would not be much use.

**User Stories**

1. As a new student who is still navigating the school and unsure of what CCA to join or even what is available, I can use the app to browse the available choices and make an informed decision. I can find the right channels to contact a CCA if I have questions. I can also follow/subscribe to certain CCAs that I take interest in so as to receive updates regarding any activities they might be holding.

2. As an organising member of a CCA, I can use the app to educate and raise awareness of what we do. I can also publicise activities/sales that are open to everyone. I can manage my own CCA page so I can always keep others updated.

3. As someone that is looking to start an interest group that is not yet available, I can find like minded people with the app.

**Tech Stack**

**1. Git and GitHub**

Git and GitHub were used for version control of our project. We opted to use a basic Centralised Workflow with 1 branch (master) on the remote repository since this project is relatively small scale with only 2 contributors. The GitHub link can be found on the first page of this document.

**2. Flutter**

Flutter is a UI toolkit created by Google &#39;for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase&#39;. We decided to use Flutter as it allows for flexible and expressive customisations. It is also supposedly easy to pick up which was essential to us as we did not have a lot of time to learn the technology. In our project, we focus on Android app development so we only tested on Android devices. However, Flutter uses a single codebase across different devices which means our code is technically portable to ios and desktop as well. This could be a future extension.

**3. Dart**

Dart is the programming language that Flutter uses, hence we had to learn it. It is likewise developed by Google for apps on multiple platforms. It is not too different from Java so learning it was manageable.

**4. Firebase (Authentication, Database, Storage)**

Firebase is a web and mobile application platform owned yet again by Google. It provides various services for developing applications. Firebase can be used for free and is pay-as-you-go. Since our app is relatively lightweight and does not have any users yet, we did not have to pay.

We used as part of our back-end:

**Authentication** - to register and verify users since our app requires login. Ideally authentication should be done through NUS&#39;s own back-end service to ensure the user is a legitimate NUS student or staff. However, for purposes of this project we make use of Firebase instead.

**Database** - to store data such as CCA information, user preferences etc. (See Database Design section below for more details)

**Storage services** - to store images that users upload like CCA display pictures

**5. Android Studio**

We used Android Studio as our IDE for this project. We also used its Android Emulator to run and test our code.

**Database Design**

Firebase Database is a NoSQL database which is structured differently from usual SQL databases. Data in NoSQL is stored in Documents under Collections and not tables like SQL.

We used 3 Collections in our database: Users, CCAs and Events.

**Features**

**For CCAs**

1. CCA members can create their CCA page on the NUS WhatToDo app. The first user that creates the CCA will automatically become an Admin of that CCA page.

2. Admins can then add and delete other admins.

3. Admins can post information about the CCA such as CCA description, contact details etc.

4. Admins can create and publish special Events that the CCA is organising. Information such as location, time, sign up instructions can be posted.

5. Admins can &#39;Close&#39; Events that are over and no longer available.

6. Admins can edit their CCA page and Event details.

7. Admins can see certain statistics that normal users cannot such as number of page Favourites and number of Event bookmarks.

**For Users**

1. All users are required to have an account and have to sign up once before they can use the app.

2. Users can change their password inside the app if needed. They can also log out from the application.

3. Users that are CCA members can create CCA pages in the app as mentioned above. They will then be added as Admins of that CCA.

4. Users can browse CCAs on the &#39;Explore&#39; page. They have the option to browse by their Favourites, by category (categories referenced from NUS Student Organisations Directory) or browse everything.

5. Users can learn about various CCAs conveniently from the first-hand information that CCAs post on their pages.

6. Users can add and remove CCAs to their list of Favourites for easy access in the future.

7. Users can browse Events on the &#39;Event Feed&#39; page. They have the option to browse by category, or browse everything.

8. Users can add and remove Events to their list of Bookmarks for easy reference in the future. They can access their bookmarks from the &#39;My Events&#39; page.

**Challenges Faced**

All the technology mentioned in the Tech Stack was new to us so it was no surprise that we frequently encountered roadblocks that required much Googling and brainstorming to solve. Some of the methods and solutions we came up with were probably not the best way to accomplish certain tasks but we take them as lessons learnt. Most of the problems faced were due to front-end and back-end integration and having to unify and coordinate two different technologies. Here we highlight problems that caused us some frustration.

**Firebase Authentication and Integration with Flutter:**

It was a challenge solving how to integrate Firebase Authentication with Flutter&#39;s UI. Firebase&#39;s API does not show how to perform operations using Dart. In Addition, some of the methods and properties documented in the Firebase API were different when using Dart. Hence, it was tough figuring out the details. In particular, we had trouble making the app &#39;remember&#39; the user that is logged in. By then we had implemented authentication and log in at the Sign-In page but we did not know how to proceed beyond that. To illustrate, after the user gets past the Sign-In page and navigates to the Profile page, how would the Profile page &#39;know&#39; who the user that signed in is? We spent a few days watching tutorial videos and searching StackOverflow. We learnt the importance of proper documentation

**Asynchronous Database Querying:**

The Firebase Database API uses asynchronous methods to query data from the Collections and Documents. Neither of us was very familiar with asynchronous programming. This led to some confusion and problems because there were unexpected side effects to the querying. The first time we encountered this problem was when implementing the Profile Page, we had to query user data to display on the page. However, nothing was displayed on the Profile Page (see image below) even though we could see that the database query was successful. We spent hours on this because we did not know where the problem was. Eventually we realised that the app page was building before the query completed because the query was asynchronous so nothing was displayed. We had to do some research and learnt to use FutureBuilder or similar Flutter widgets whenever dealing with asynchronous operations.