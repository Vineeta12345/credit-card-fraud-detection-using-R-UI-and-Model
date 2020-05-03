#importing dataset
credit_card <- read.csv('C:\\Users\\Vineeta\\Desktop\\vlad-credit-card-fraud-detection\\CC.csv')
#observing the dataset
str(credit_card)
#converting class to factor variable
credit_card$Class <- factor(credit_card$Class, levels = c(0,1))
#summary of dataset
summary(credit_card)
#counting the missing values
sum(is.na(credit_card))
#-----Calculating fraud and legit transactions in data set-----
#get the distribution of fraud and legit data
table(credit_card$Class)
#get the percent distribution of fraud and legit data
prop.table(table(credit_card$Class))
#pie chart of transactions
labels <- c("legit","fraud")
labels <- paste(labels, round(100*prop.table(table(credit_card$Class)), 2))
labels <- paste0(labels,"%")
pie(table(credit_card$Class), labels, col = c("pink","white"), 
    main = "Pie chart of fraud and legit credit card transactions")
#------NO MODEL PREDICTION------
#assuming all transactions as legitimate transactions
predictions <- rep.int(0, nrow(credit_card))
predictions <- factor(predictions, levels = c(0,1))
#install.packages('caret')
library(caret)
# confusion matrix is very imp for tree building
confusionMatrix(data = predictions, reference = credit_card$Class)
#----Building the model-----
library(dplyr)
set.seed(1)
table(credit_card$Class)
library(ggplot2)
ggplot(data = credit_card, aes(x = V1, y = V2, col = Class))+
  geom_point()+
  theme_bw()+
  scale_color_manual(values = c('dodgerblue2','red'))
#-----Creating training and test set for fraud detection----
#install.packages('caTools')
library(caTools)
set.seed(123)
data_sample = sample.split(credit_card$Class,SplitRatio = 0.80)
train_data = subset(credit_card,data_sample==TRUE)
test_data = subset(credit_card,data_sample==FALSE)
dim(train_data)
dim(test_data)
#--------Balancing the dataset------
#Random Over Sampling(duplicating the number of fraud cases)
#in this method we duplicate the number of fraud cases
table(train_data$Class)
n_legit <- 227452
new_frac_legit <- 0.50
new_n_total <- n_legit/new_frac_legit
#install.packages('ROSE')
library(ROSE)
oversampling_result <- ovun.sample(Class ~ .,
                                   data = train_data,
                                   method = "over",
                                   N = new_n_total,
                                   seed = 2019)
oversampled_credit <- oversampling_result$data
table(oversampled_credit$Class)
ggplot(data = oversampled_credit, aes(x = V1, y = V2, col = Class))+
  geom_point(position = position_jitter(width = 0.2))+
  theme_bw()+
  scale_color_manual(values = c('dodgerblue2','red'))
#random under sampling(reducing the number of legitimate cases)
table(train_data$Class)
n_fraud <- 394
new_frac_fraud <- 0.50
new_n_total <- n_fraud/new_frac_fraud
undersampling_result <- ovun.sample(Class ~ .,
                                    data = train_data,
                                    method = "under",
                                    N = new_n_total,
                                    seed = 2019)
undersampled_credit <- undersampling_result$data
table(undersampled_credit$Class)
ggplot(data = undersampled_credit, aes(x = V1, y = V2, col = Class))+
  geom_point()+
  theme_bw()+
  scale_color_manual(values = c('dodgerblue2','red'))
#random under sampling and random over sampling both(fraud data overlapped each other due to duplicacy) 
n_new <- nrow(train_data)
fraction_fraud_new <- 0.50
sampling_result <- ovun.sample(Class ~ .,
                               data = train_data,
                               method = "both",
                               N = n_new,
                               p = fraction_fraud_new,
                               seed = 2019)
sampled_credit <- sampling_result$data
table(sampled_credit$Class)
prop.table(table(sampled_credit$Class))
ggplot(data = sampled_credit, aes(x = V1, y = V2, col = Class))+
  geom_point(position = position_jitter(width = 0.2))+
  theme_bw()+
  scale_color_manual(values = c('dodgerblue2','red'))
#SMOTE method(synthetic minority oversampling technique)[adding synthetic points to the dataset removing duplicacy]
#install.packages('smotefamily')
library(smotefamily)
table(train_data$Class)
#setting the number of fraud and legitimate cases in smote
n0 <- 227452
n1 <- 394
r0 <- 0.6
ntimes <- ((1 - r0) / r0) * (n0 / n1) - 1
smote_output <- SMOTE(X = train_data[ , -c(1,32)],
                      target = train_data$Class,
                      K = 5,
                      dup_size = ntimes)
credit_smote <- smote_output$data
colnames(credit_smote)[31] <- "Class"
table(credit_smote$Class)
prop.table(table(credit_smote$Class))
ggplot(data = credit_smote, aes(x = V1, y = V2, col = Class))+
  geom_point()+
  theme_bw()+
  scale_color_manual(values = c('dodgerblue2','red'))
#--------TRAINING OUR MODEL-------
#training on credit_smote dataset
#designing a decision tree to predict whether a transaction is fraud or legit
#install.packages('rpart')
#install.packages('rpart.plot')
library(rpart)
library(rpart.plot)
CART_model <- rpart(Class ~ ., credit_smote)
rpart.plot(CART_model, extra = 0, type = 5, tweak = 1.2)
#predicting fraud classes
predicted_val <- predict(CART_model, test_data, type = 'class')
#build confusion matrix for test data
library(caret)
confusionMatrix(predicted_val, test_data$Class)
#Training on credit_card dataset
predicted_val <- predict(CART_model, credit_card[-1], type = 'class')
confusionMatrix(predicted_val,credit_card$Class)
#training on train_data datset
CART_model <- rpart(Class ~ ., train_data[,-1])
rpart.plot(CART_model, extra = 0, type = 5, tweak = 1.2)
#predicting fraud classes
predicted_val <- predict(CART_model, test_data[, -1], type = 'class')
library(caret)
confusionMatrix(predicted_val, test_data$Class)
#predicting on whole credit_card dataset
predicted_val <- predict(CART_model, credit_card[-1], type = 'class')
confusionMatrix(predicted_val, credit_card$Class)
#--------WITHOUT SMOTE-------
#decision tree without smote(unbalanced dataset)
CART_model <- rpart(Class ~ ., train_data[,-1])
rpart.plot(CART_model, extra = 0, type = 5, tweak = 1.2)
#predicting fraud classes
predicted_val <- predict(CART_model, test_data[,-1], type = 'class')
library(caret)
confusionMatrix(predicted_val, test_data$Class)
#prediction on whole dataset
predicted_val <- predict(CART_model, credit_card[-1], type = 'class')
confusionMatrix(predicted_val, credit_card$Class)
#----------------------END---------------------------------------------------------------------------------------------