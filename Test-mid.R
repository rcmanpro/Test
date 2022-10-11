library(data.table);library(magrittr);library(ggpubr);library(rvg);library(officer) 
a <- fread("https://raw.githubusercontent.com/jinseob2kim/R-skku-biohrs/main/data/example_g1e.csv")

var.factor <- grep("Q_", names(a), value = T)

var.factor

var.conti <- names(a)[!(names(a) %in% var.factor)]

var.conti

a[, (var.factor) := lapply(.SD, as.factor), .SD = var.factor]
a[, (var.conti) := lapply(.SD, as.numeric), .SD = var.conti]

sapply(a, class)


both <- aggregate(cbind(WSTC, BMI) ~ EXMD_BZ_YYYY, data = a, function(x){c(mean = mean(x), sd = sd(x))})

aggregate(a[,c("WSTC","BMI")], list(a$EXMD_BZ_YYYY), mean)  # 연도별 평균

aggregate(a[,c("WSTC","BMI")], list(a$EXMD_BZ_YYYY), sd)    # 연도별 표준 편차 

aggregate(cbind(WSTC, BMI) ~ EXMD_BZ_YYYY, data = a, function(x){c(mean = mean(x), sd = sd(x))})

# Boxplot 그리기 
p <- ggboxplot(data= a, x= "EXMD_BZ_YYYY", y= "FBS")

ggboxplot(data= a, x= "EXMD_BZ_YYYY", y= "FBS")

# pptx로 저장하기
plot_file <- read_pptx() %>%
  add_slide() %>% ph_with(dml(ggobj = p), location = ph_location_type(type="body"))
print(plot_file, target = "plot_file.pptx")
