# PlantiPal - Plant ID and Plant Care Guide Swift Application

<h2>Project Overview</h2>
<p>PlantiPal is an innovative mobile application designed to assist users in identifying plant species through photographs. The application provides a user-friendly interface to help you discover and learn more about the plants around you. With just a photo, users can quickly identify unknown plants, making it a valuable tool for anyone interested in botany or outdoor exploration.</p>

<h2>Core Functionalities</h2>
<p>The primary feature of PlantiPal is its ability to identify plant species from user-uploaded photos. Users can either take a photo on the spot or choose one from their gallery. PlantiPal then processes the image using its custom-trained model, which reaches an accuracy rate of 94%. In cases where the custom model struggles to make a confident prediction, PlantiPal integrates with the Pl@ntNet API, a robust external model capable of identifying up to 1,081 plant species with a 95% accuracy rate. This dual-model approach ensures that users receive reliable identification results, even for less common plants.</p>

<p>After identifying a plant, users can save it to their personal "virtual garden" within the app. PlantiPal remembers the species and allows users to categorize the plant as either an indoor or outdoor one, assign it a custom name, and receive tailored care notifications. For outdoor plants, PlantiPal will alert users of adverse weather conditions, such as storms or frost, advising them to protect their plants. Additionally, based on the species' watering needs, users will receive regular reminders to keep their plants healthy and well-maintained. The app also stores detailed information about each plant, enabling users to easily reference care instructions and species details at any time.</p>

<p>The user's virtual garden includes its own journal, where users can document important milestones and observations. These entries, which include a title, content, date, and time, allow users to track the growth and development of their plants over time. This feature is particularly useful for monitoring key stages such as seed germination, leaf emergence, flowering, and fruiting. By keeping detailed records, users can better understand their plants' growth patterns and overall health.</p>

<p>PlantiPal also features a "Perfect Plant Finder" quiz, designed to help users find the ideal plant for their environment and lifestyle. The quiz consists of 10 questions that assess factors such as natural light availability, watering frequency, space constraints, humidity levels, and whether the user has pets or allergies. </p>

<p>PlantiPal serves as a valuable resource for those interested in botanical research. The app includes a dedicated articles page that aggregates open-access research papers from PLOS (Public Library of Science), providing users with access to the latest scientific discoveries and original research in plant science. Additionally, PlantiPal offers a feature that displays the most-searched plants of the day on iNaturalist, with links directing users to the corresponding Wikipedia pages for more information.
</p>

<h2>Technology Stack</h2>
<p>PlantiPal was developed using Swift, a modern programming language known for its simplicity, security, and ease of use. The app's user interface was built with UIKit, a powerful framework that simplifies the creation of intuitive and consistent user experiences across iOS and macOS. For the machine learning components, TensorFlow and Keras were utilized to define, train, and deploy the plant classification model. The PlantiPal model is based on the VGG16 architecture, employing optimizers like Adaptive Moment Estimation (Adam) and Stochastic Gradient Descent (SGD) to achieve high accuracy in plant species classification.</p>


Application developed by Ungureanu Delia Elena as part of graduation thesis.
