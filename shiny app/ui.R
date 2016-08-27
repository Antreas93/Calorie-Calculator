shinyUI(pageWithSidebar(
        headerPanel("Calorie Calculator"),
        sidebarPanel(
                textInput("name","Name"),
                radioButtons("gender","Gender:",
                            list("Male","Female")),
                numericInput("age","Age:",20,min=16),
                numericInput("height","Height(CM):",170,step=1,min=40,max=210),
                numericInput("weight","Weight(KG):",70,step = .1,min=40,max=260),
                selectInput("activity","Weekly Activity:",
                            list("Low Intensity"=1.2,
                                 "Light Excercise"=1.375,
                                 "Moderate Exercise"=1.55,
                                 "Active Individual"=1.725,
                                 "Extremely Active Individual"=1.9)),
                sliderInput("nmeals","Number of Meals",3,7,4,step=1),
                selectInput("target","Target",
                            list("Lean Muscle Gain"=1.10,
                                 "Fat Loss 5% Calorie Reduction"=.95,
                                 "Fat Loss 10% Calorie Reduction"=.9,
                                 "Fat Loss 15% Calorie Reduction"=.85)),
                selectInput("macros","Macros Combination",
                            list("20% protein 55% carbs 25% fat"=1,
                                 "30% protein 45% carbs 25% fat"=2,
                                 "40% protein 40% carbs 20% fat"=3,
                                 "45% protein 40% carbs 15% fat"=4,
                                 "45% protein 30% carbs 25% fat"=5))
                
        ),
        mainPanel(
                tabsetPanel(
                        tabPanel("Calorie and BMI Calculation",
                                 h2("Data Entered"),
                                 tableOutput("entered"),
                                 h2("Results"),
                                 tableOutput("results"),
                                 helpText("*The results of the calculator are 
                                          based on an estimated average."),
                                 downloadButton("pdf_dl","Download PDF file"),
                                 downloadButton("xls_dl","Download Excel file")),
                        tabPanel("BMI Information",
                                 h2("Body Mass Index"),
                                 helpText("Body Mass Index(BMI)
                                        is a value derived from the mass and height of an individual. 
                                          It is defined by the body mass in kg
                                          divided by the square of the body height in meters. "),
                                 h2("BMI Reference Table"),
                                 tableOutput("bmit")),
                        tabPanel("Documentation",
                                 h3("General Information"),
                                 helpText("This calorie calculator calculates the optimal calorie intake and macro-nutrient values to lose fat or gain muscle."),
                                 helpText("Generally losing weight comes in three easy steps:",HTML("<br><br>"),
                                          HTML("<ol><li>Exercise a bit more</li><br>
                                          <li>Eat a bit less</li><br>
                                          <li>Drink a lot of water</li></ol>"),HTML("<br><br>"),
                                          "To use this calculator you just need to enter your information.",HTML("<br>"),
                                          "You can download your data as a pdf or an excel file for future reference."),
                                 h3("Weekly Activity"),
                                 helpText(HTML("<br>"),HTML("<br>"),
                                          HTML("<ul><li>Low Intensity: leisure activities and primarily sedentary life</li></ul>"),HTML("<br>"),
                                          HTML("<ul><li>Light Excercise: leisure walking 30-40minutes, 3-4 days/week</li></ul>"),HTML("<br>"),
                                          HTML("<ul><li>Moderate Excercise: moderate intensity 30-60minutes, 3-4 days/week</li></ul>"),HTML("<br>"),
                                          HTML("<ul><li>Active Individual: moderate-high intensity 45-60minutes, 6-7days/week</li></ul>"),HTML("<br>"),
                                          HTML("<ul><li>Extremely Active Individual: heavy/intense excercise 90+minutes,
                                               6-7 days/week (eg. manual labor,heavy lifting,competitive team sports)</li></ul>")),
                                 h3("Macros Combinations"),
                                 helpText("You can set it to a combination that better suits your life and your appetite.",
                                          HTML("<br>"),"However if you are serious about losing fat i suggest that you choose 
                                          your protein to be 40% or more."))
                        
                ))     

                
))