# get_predigests <- function(x) {
#   paths <- list.files(path = x,
#                       full.names = T,
#                       recursive = T)
#   files <- basename(paths)
#   return(files)
# }
#
#
#
# ss.con <- function(data, vars,digits.n=1,vars.label=NULL){ element.all2<- NA
#
#   if(is.null(vars.label)) vars.label= vars
#
#   if(length(vars.label)!=length(vars)){
#
#     print('Error: length of variable labels is incorrect!')
#
#   } else {
#
#     for(i in 1:length(vars)){
#
#       var.i<- vars[i]
#
#       summ<- summary(data[,var.i])
#
#       sdsd<- sd(data[,var.i],na.rm = T)
#
#       nn<- sum(length(which(!is.na(data[,var.i]))))
#
#       element2<- list(vars.label[i], nn,round(summ[3],digits = digits.n), paste0(round(summ[2],digits = digits.n),' - ',round(summ[5],digits = digits.n)), round(summ[4],digits =
#                       digits.n), round(sdsd,digits = digits.n), round(summ[1],digits = digits.n), round(summ[6],digits = digits.n))
#
#       element.data2<- Reduce(cbind,element2)
#
#       element.all2<- data.frame(rbind(element.all2,element.data2))
#
#     }
#
#     element.all2<- element.all2[-1,] # the first line is just NA
#
#     rownames(element.all2)<- NULL # remove the rownames
#
#     names(element.all2)<- c('Variable','N','Median','IQR','Mean','SD','Min','Max') #add these row names
#
#     return(element.all2)
#
#   }
# }
#
#
# plot.histo <- function(long.df) {
#   ggplot(data = long.df, aes(x = COUNT, fill = TYPE)) +
#     geom_histogram(alpha = 0.4, bins = 100, position = 'identity') +
#     scale_x_continuous(expand = c(0, 0), limits = c(0, 200)) +
#     scale_y_continuous(expand = c(0, 0)) +
#     # theme(plot.margin = unit(c(1,1,1.5,1.2), "cm")) +
#     theme(legend.title = element_text(size = 16, vjust = 0.95, face = "bold")) +
#     theme(plot.background = element_blank(),
#           panel.background = element_rect(fill = 'transparent', size = 1)) +
#     theme(axis.title.x = element_text(size = 16, face = "bold", margin = margin(t = 10)),
#           axis.text.x = element_text(size = 14, face = "bold", color = "black", margin = margin(t = 8)),
#           axis.title.y = element_text(size = 16, face = "bold", margin = margin(r = 8)),
#           axis.text.y = element_text(size = 14, face = "bold", color = "black")) +
#     theme(panel.border = element_rect(color = "black", fill = NA, size = 2))
# }
