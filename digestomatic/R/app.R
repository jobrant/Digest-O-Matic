# setwd("/srv/shiny-server/DIGEST/")

# x <- c('Matrix', 'shiny', 'shinyFiles', 'DT', 'shinyWidgets',
#        'styler', 'shinyAce', 'shinyjqui', 'shinyEffects', 'plotly', 'openxlsx',
#        'ggrepel', 'shinythemes', 'ggfortify', 'ggplot2', 'shinydashboard',
#        'stringr', 'pheatmap', 'tidyverse', 'heatmaply', 'data.table',
#        'reshape2', 'scales')
# lapply(x, require, character.only = T)


# e.table <- read.table('neb_enzymes.tsv', sep = '\t', header = T)
#
# source('APP_FUNCTIONS/global_options.R')
# source('APP_FUNCTIONS/helper_functions.R')
#
#
# ui <- navbarPage(
#   theme =  shinytheme('flatly'),
#   title = 'Digest-O-Matic',
#
#   tabPanel(
#     title = 'Genome Digestion Metrics',
#     sidebarLayout(
#       sidebarPanel(
#         width = 3,
#         pickerInput(
#           inputId = "isd_genome",
#           label = "Choose Genome Build for Digest",
#           choices = c('Human', 'Mouse'),
#           selected = 'Human'
#         ),
#
#         uiOutput('isd_predigest1'),
#
#         uiOutput('isd_predigest2'),
#
#         sliderInput(
#           inputId = 'isd_length1',
#           label = 'Choose fragment length range for 1st genome',
#           min = 50,
#           max = 2000,
#           value = c(200, 400),
#           step = 50,
#           round = T,
#           animate = F
#
#         ),
#
#         sliderInput(
#           inputId = 'isd_length2',
#           label = 'Choose fragment length range for 2nd genome',
#           min = 50,
#           max = 2000,
#           value = c(200, 400),
#           step = 50,
#           round = T,
#           animate = F)
#
#
#     ), # sidebarpanel
#
#     mainPanel(
#       fluidRow(
#         tabBox(
#           title = 'Digest 1',
#           id = 'isd1_histo',
#           width = 6,
#           height = 540,
#           tabPanel(title = 'HCG sites',
#                    plotOutput('isd1_hcg_sites_histo')),
#           tabPanel(title = 'GCH sites',
#                    plotOutput('isd1_gch_sites_histo')),
#           tabPanel(title = 'Length distibution',
#                    plotOutput('isd1_length_histo'))
#         ),
#
#         tabBox(
#           title = 'Digest 2',
#           id = 'isd2_histo',
#           width = 6,
#           height = 540,
#           tabPanel(title = 'HCG Sites',
#                    plotOutput('isd2_hcg_sites_histo')),
#           tabPanel(title = 'GCH sites',
#                    plotOutput('isd2_gch_sites_histo')),
#           tabPanel(title = 'Length distibution',
#                    plotOutput('isd2_length_histo'))
#         )
#       ),
#
#       fluidRow(
#         tabBox(
#           title = 'Digest metrics table',
#           id = 'isd1_table',
#           width = 6,
#           height = 540,
#           tabPanel(title = 'Digestion 1 Stats',
#                    DT::DTOutput('ISD_table2.1')),
#           tabPanel(title = 'Digested Fragments',
#                    DT::DTOutput('ISD_table1.1'))
#         ),
#         tabBox(
#           title = 'Digest metrics table',
#           id = 'isd2_table',
#           width = 6,
#           height = 540,
#           tabPanel(title = 'Digestion 2 Stats',
#                    DT::DTOutput('ISD_table2.2')),
#           tabPanel(title = 'Digested Fragments',
#                    DT::DTOutput('ISD_table1.2'))
#         )
#       )
#     ) # mainpanel
#
#     ), # sidebarlayout
#
#
#   ), # tabpanel
#
#
# ) # navbarpage
#
#
# server <- function(input, output, session) {
#
#   observe({
#     req(input$isd_genome)
#     choices <<- get_predigests(paste(project_path, 'APP_DATA', sep = '/'))
#     # cat(file = stderr(), paste0('choices equals  ', choices))
#     genome <<- get_genome(input$isd_genome)
#     cat(file = stderr(), paste0('genome equals  ', genome, '\n'))
#   })
#
#   output$isd_predigest1 <- renderUI({
#     req(input$isd_genome)
#     pickerInput(
#       inputId = "predigest1",
#       label = "Select 1st Predigested Genome",
#       choices = choices[grepl(x = choices, pattern = genome)],
#       options = list(
#         title = "Select dataset"),
#       choicesOpt = list(style = colors()))
#   })
#
#   output$isd_predigest2 <- renderUI({
#
#     pickerInput(
#       inputId = "predigest2",
#       label = "Select 2nd Predigested Genome",
#       choices = choices[grepl(x = choices, pattern = genome)],
#       options = list(
#         title = "Select dataset"),
#       choicesOpt = list(style = colors())
#     )
#   })
#
#   observe({
#
#     req(input$isd_genome)
#
#     isd1 <- reactive({
#       req(input$predigest1)
#       # cat(file = stderr(), paste0('isd1 reactive  ',
#       #                             paste(project_path, 'APP_DATA', input$predigest1, sep = '/')))
#       tmp <- fread(paste(project_path, 'APP_DATA', input$predigest1, sep = '/'), sep = '\t', header = T)
#     })
#
#     isd1.filtered <- reactive({
#       tmp <- isd1()
#       tmp <- subset(tmp, tmp$length >= input$isd_length1[1] &
#                       tmp$length <= input$isd_length1[2])
#     })
#
#     isd2 <- reactive({
#       req(input$predigest2)
#       tmp <- fread(paste(project_path, 'APP_DATA', input$predigest2, sep = '/'), sep = '\t', header = T)
#     })
#
#     isd2.filtered <- reactive({
#       tmp <- isd2()
#       tmp <- subset(tmp, tmp$length >= input$isd_length2[1] &
#                       tmp$length <= input$isd_length2[2])
#     })
#
#     isd1.hcg.long <- reactive({
#       tmp <- isd1.filtered()
#       tmp <- tmp[, c(5, 7)]
#       tmp <- subset(tmp, is.finite(tmp$HCG_occurrence))
#       tmp <- tidyr::gather(tmp, TYPE, COUNT)
#     })
#
#     isd1.gch.long <- reactive({
#       tmp <- isd1.filtered()
#       tmp <- tmp[, c(6, 8)]
#       tmp <- subset(tmp, is.finite(tmp$GCH_occurrence))
#       tmp <- tidyr::gather(tmp, TYPE, COUNT)
#     })
#
#     isd2.hcg.long <- reactive({
#       tmp <- isd2.filtered()
#       tmp <- tmp[, c(5, 7)]
#       tmp <- subset(tmp, is.finite(tmp$HCG_occurrence))
#       tmp <- tidyr::gather(tmp, TYPE, COUNT)
#     })
#
#     isd2.gch.long <- reactive({
#       tmp <- isd2.filtered()
#       tmp <- tmp[, c(6, 8)]
#       tmp <- subset(tmp, is.finite(tmp$GCH_occurrence))
#       tmp <- tidyr::gather(tmp, TYPE, COUNT)
#     })
#
#
#     table1 <- reactive({
#
#       tmp1 <- isd1.filtered()
#       tmp1 <- datatable(tmp1,
#                         extensions = c('FixedColumns',
#                                        'FixedHeader',
#                                        'Scroller'),
#                         class = 'display nowrap',
#                         options = expTblOptions,
#                         rownames = F )
#     })
#
#     output$ISD_table1.1 <- DT::renderDT(
#       table1()
#     )
#
#
#     table2 <- reactive({
#
#       tmp2 <- isd2.filtered()
#
#       tmp2 <- datatable(tmp2,
#                         extensions = c('FixedColumns',
#                                        'FixedHeader',
#                                        'Scroller'),
#                         class = 'display nowrap',
#                         options = expTblOptions,
#                         rownames = F )
#     })
#
#     output$ISD_table1.2 <- DT::renderDT(
#       table2()
#     )
#
#
#     table3 <- reactive({
#
#       tmp1 <- as.data.frame(isd1.filtered())
#       tmp1 <- ss.con(data = tmp1,
#                    vars = c('length', 'HCG_sites', 'GCH_sites', 'HCG_occurrence', 'GCH_occurrence'),
#                    vars.label = c('Length of Fragments',
#                                   'Number HCG Sites',
#                                   'Number GCH Sites',
#                                   'HCG Frequency in bp',
#                                   'GCH Frequency in bp'))
#      tmp1 <- datatable(tmp1,
#                         extensions = c('FixedColumns',
#                                        'FixedHeader',
#                                        'Scroller'),
#                         class = 'display nowrap',
#                         options = expTblOptions,
#                         rownames = F )
#     })
#
#     output$ISD_table2.1 <- DT::renderDT(
#       table3()
#     )
#
#     table4 <- reactive({
#
#       tmp1 <- as.data.frame(isd2.filtered())
#
#       tmp1 <- ss.con(data = tmp1,
#                    vars = c('length', 'HCG_sites', 'GCH_sites', 'HCG_occurrence', 'GCH_occurrence'),
#                    vars.label = c('Length of Fragments',
#                                   'Number HCG Sites',
#                                   'Number GCH Sites',
#                                   'HCG Frequency in bp',
#                                   'GCH Frequency in bp'))
#       tmp1 <- datatable(tmp1,
#                         extensions = c('FixedColumns',
#                                        'FixedHeader',
#                                        'Scroller'),
#                         class = 'display nowrap',
#                         options = expTblOptions,
#                         rownames = F )
#     })
#
#     output$ISD_table2.2 <- DT::renderDT(
#       table4()
#     )
#
#     output$isd1_hcg_sites_histo <- renderPlot({
#
#      tmp <- isd1.hcg.long()
#
#      tmp <- tmp[grepl(x = tmp$TYPE, pattern = '^HCG'), ]
#
#      plot.histo(tmp)
#
#     })
#
#     output$isd1_gch_sites_histo <- renderPlot({
#
#       tmp <- isd1.gch.long()
#
#       tmp <- tmp[grepl(x = tmp$TYPE, pattern = '^GCH'), ]
#
#       plot.histo(tmp)
#
#     })
#
#     output$isd1_length_histo <- renderPlot({
#
#       tmp <- isd1.filtered()
#
#       ggplot(data = tmp, aes(x = length,)) +
#         geom_histogram(alpha = 0.4, bins = 50, position = 'identity') +
#         scale_x_continuous(expand = c(0, 0)) +
#         scale_y_continuous(expand = c(0, 0)) +
#         theme(plot.margin = unit(c(1,1,1.5,1.2), "cm")) +
#         theme(legend.title = element_text(size = 16, vjust = 0.95, face = "bold")) +
#         theme(plot.background = element_blank(),
#               panel.background = element_rect(fill = 'transparent', size = 1)) +
#         theme(axis.title.x = element_text(size = 16, face = "bold", margin = margin(t = 10)),
#               axis.text.x = element_text(size = 14, face = "bold", color = "black", margin = margin(t = 8)),
#               axis.title.y = element_text(size = 16, face = "bold", margin = margin(r = 8)),
#               axis.text.y = element_text(size = 14, face = "bold", color = "black")) +
#         theme(panel.border = element_rect(color = "black", fill = NA, size = 2))
#
#     })
#
#     output$isd2_hcg_sites_histo <- renderPlot({
#
#       tmp <- isd2.hcg.long()
#
#       tmp <- tmp[grepl(x = tmp$TYPE, pattern = '^HCG'), ]
#
#       plot.histo(tmp)
#
#     })
#
#     output$isd2_gch_sites_histo <- renderPlot({
#
#       tmp <- isd2.gch.long()
#
#       tmp <- tmp[grepl(x = tmp$TYPE, pattern = '^GCH'), ]
#
#       plot.histo(tmp)
#
#     })
#
#     output$isd2_length_histo <- renderPlot({
#
#       tmp <- isd2.filtered()
#
#       ggplot(data = tmp, aes(x = length,)) +
#         geom_histogram(alpha = 0.4, bins = 50, position = 'identity') +
#         scale_x_continuous(expand = c(0, 0)) +
#         scale_y_continuous(expand = c(0, 0)) +
#         theme(plot.margin = unit(c(1,1,1.5,1.2), "cm")) +
#         theme(legend.title = element_text(size = 16, vjust = 0.95, face = "bold")) +
#         theme(plot.background = element_blank(),
#               panel.background = element_rect(fill = 'transparent', size = 1)) +
#         theme(axis.title.x = element_text(size = 16, face = "bold", margin = margin(t = 10)),
#               axis.text.x = element_text(size = 14, face = "bold", color = "black", margin = margin(t = 8)),
#               axis.title.y = element_text(size = 16, face = "bold", margin = margin(r = 8)),
#               axis.text.y = element_text(size = 14, face = "bold", color = "black")) +
#         theme(panel.border = element_rect(color = "black", fill = NA, size = 2))
#
#     })
#
#   }) # observe
#
# }
#
# shinyApp(ui = ui, server = server)
#
