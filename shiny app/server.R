library(shiny);library(printr);library(gridExtra);library(xlsx)

bmit<-data.frame(matrix(nrow = 8,ncol = 2))

bmit$Category<-c("Severe Thinness","Moderate Thinness","Mild Thinness",
                 "Normal","Overweight",
                 "Obese Class I","Obese Class II","Obese Class III")
bmit$'BMI Range - kg/(m^2)'<-c("<16","16-17","17-18.5",
                               "18.5-25","25-30","30-35","35-40",">40")
bmit<-bmit[,3:4]
activity<-c("Low Intensity"=1.2,
           "Light Excercise"=1.375,
           "Moderate Exercise"=1.55,
           "Active Individual"=1.725,
           "Extremely Active Individual"=1.9)
target_<-list("Lean Muscle Gain"=1.10,
              "Fat Loss 5% Calorie Reduction"=.95,
              "Fat Loss 10% Calorie Reduction"=.9,
              "Fat Loss 15% Calorie Reduction"=.85)
macros_<-list("20% protein 55% carbs 25% fat"=1,
            "30% protein 45% carbs 25% fat"=2,
            "40% protein 40% carbs 20% fat"=3,
            "45% protein 40% carbs 15% fat"=4,
            "45% protein 30% carbs 25% fat"=5)

macros_values<-data.frame(x.1=c(.2,.55,.25),x.2=c(.30,.45,.25),x.3=c(.4,.4,.2),
                          x.2=c(.45,.4,.15),x.5=c(.45,.3,.25))

shinyServer(function(input,output){
        bmi<-reactive({
                round(input$weight/((input$height/100)^2),2)
        })
       bmi_status<-reactive({
                if (bmi()<18.5){
                        status<-"Underweight"       
                }
                if ((18.5<=bmi()) & (bmi()<25)){
                        status<-"Normal"
                }
                if ((25<=bmi()) & (bmi()<30)){
                        status<-"Overweight"
                }
                if (bmi()>=30){
                        status<-"Obese"
                }
                status
        })
        output$bmit<-renderTable({
                bmit
        })
        
        bmr<-reactive({
                if (input$gender=="Male"){
                        bmr<-round((66.47+13.75*input$weight+
                                            5*input$height-6.75*input$age),0)
                }
                else {
                        bmr<-round((665.09+9.56*input$weight+
                                       1.84*input$height-4.67*input$age),0)
                }
                bmr
        })
        calories<-reactive({
                        calories<-round(bmr()*as.numeric(input$activity),0)
        })    
        tcalories<-reactive({
                calories()*as.numeric(input$target)
        })
        cal_meal<-reactive({
                round(tcalories()/input$nmeals,0)
        })
       protein_daily<-reactive({
                percentage<-macros_values[1,as.numeric(input$macros)]
                cal_protein<-tcalories()*percentage
                round(cal_protein/4,0)
        })
        protein<-reactive({
                round(protein_daily()/as.numeric(input$nmeals))
        })
       carbs_daily<-reactive({
                percentage<-macros_values[2,as.numeric(input$macros)]
                cal_carbs<-tcalories()*percentage
                round(cal_carbs/4,0)
        })
        carbs<-reactive({
                round(carbs_daily()/as.numeric(input$nmeals))
        })
        fat_daily<-reactive({
                percentage<-macros_values[3,as.numeric(input$macros)]
                cal_fat<-tcalories()*percentage
                round(cal_fat/9,0)
        })
        fat<-reactive({
                round(fat_daily()/as.numeric(input$nmeals))
        })
        tt<-reactive({
                tt<-data.frame(matrix(nrow = 9,ncol = 2))
                names(tt)<-c("Fields","Data Entered")
                tt$Fields<-c("Name","Gender","Age","Height","Weight","Weekly Activity",
                             "Number of Daily Meals","Target","Macros Combination")
                tt$'Data Entered'<-c(input$name,input$gender,input$age,input$height,
                                     input$weight,names(activity[activity==input$activity]),
                                     input$nmeals,names(target_[target_==input$target]),
                                     names(macros_[macros_==input$macros]))
                tt
        })
        tt2<-reactive({
                tt2<-data.frame(matrix(nrow = 13,ncol=2))
                names(tt2)<-c("Fields","Results")
                tt2$Fields<-c("BMI","Weight Status","Basal Metabolic Rate(BMR)",
                             "Daily Caloric Needs",
                             "Daily Caloric Needs According To Target",
                             "Daily Protein Requirements(grams)",
                             "Daily Carbs Requirements(grams)",
                             "Daily Fat Requirements(grams)",
                             "Number of Daily Meals","Calories per Meal",
                             "Protein per Meal(grams)",
                             "Carbs per Meal(grams)","Fat per Meal(grams)")
                tt2$Results<-c(bmi(),bmi_status(),bmr(),calories(),tcalories(),
                               protein_daily(),carbs_daily(),fat_daily(),
                               input$nmeals,cal_meal(),protein(),carbs(),fat())
                tt2
        })
        output$entered<-renderTable({
                tt()
        })
        output$results<-renderTable({
                tt2()
        })
        output$pdf_dl<-downloadHandler(
                filename=function()
                        paste(input$name," Health Data.pdf",sep=""),
                content=function(file){
                        pdf(file,title="BMI and Calorie Data")
                        tt<-tt();names(tt)<-c("Fields","Value")
                        tt2<-tt2();names(tt2)<-c("Fields","Value")
                        grid.table(rbind(tt,tt2))
                        dev.off()
                }
        )
        output$xls_dl<-downloadHandler(
                filename=function()
                        paste(input$name," Health Data.xlsx",sep=""),
                content = function(file){
                        tt<-tt();tt2<-tt2()
                        write.xlsx(tt,file,row.names = FALSE,
                                   sheetName = "Personal Data")
                        write.xlsx(tt2,file,row.names = FALSE,append = TRUE,
                                   sheetName = "Results")
                }
        )
                       
                
})
