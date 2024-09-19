library(tidyverse)

d <- tibble(x = c(1:7), y = 1, covs = factor(c(0,0,1, 0,0,1,1)),
            wts = c('2','2','3','2','2','3/2','3/2'))
plt1 <- ggplot(d, aes(x, y))+geom_point(aes(fill = covs), shape = 21, size = 10,
                                show.legend=FALSE) +
  geom_vline(xintercept = 3.5, linewidth=2)+
  annotate('text',x = 2, y = 1.5, label = 'Exposed', size = 10) +
  annotate('text', x = 5.5, y = 1.5, label = "Not exposed", size=10)+
  theme_void() +
  theme(text = element_text(size = 14))+
  scale_x_continuous(limits = c(-1.5, 7.5))+
  scale_y_continuous(limits = c(0.5,1.6))+
  scale_fill_manual(values = c('0' = 'white','1' = 'black'))

png(file = "chapters/images/tmp21.png", width = 8, height = 2, units = 'in', res = 300)
plt1 +
  annotate('text', x = -1.5, y = 0.8, label = "Weights", size = 10, hjust=0)+
  geom_text(aes(x = x, y = 0.8, label = wts), size=10)
dev.off()

d2 <- d |> rbind(
  tibble(x = c(1,2,3,3,4,5,6,7), y = c(0.8, .8, .8, .6, .8, .8,.8, .8),
         covs = c(0, 0, 1, 1, 0, 0, 1, 1),
         wts = '0'
)) |>
  mutate(shps = c(rep('0',13), rep('1',2)))
plt2 <- ggplot( d2, aes(x, y))+
  geom_point(data = d2 |> filter(shps=='0'), aes(fill = covs),shape=21, size = 10,
                                show.legend=FALSE) +
  geom_point(data = d2 |> filter(shps == '1'),
             aes(fill=covs), shape = "\u25D7", size=20, show.legend=F) +
  geom_vline(xintercept = 3.5, linewidth=2)+
  annotate('text',x = 2, y = 1.5, label = 'Exposed', size = 10) +
  annotate('text', x = 5.5, y = 1.5, label = "Not exposed", size=10)+
  theme_void() +
  theme(text = element_text(size = 14))+
  scale_x_continuous(limits = c(-1.5, 7.5))+
  scale_y_continuous(limits = c(0.5,1.6))+
  scale_fill_manual(values = c('0' = 'white','1' = 'black'))

library(Cairo)
cairo_pdf('tmp2.pdf', family = 'Symbola', width=8,height=2)
plt1
dev.off()

cairo_pdf('tmp.pdf', family = "Symbola", width = 8, height = 2)
plt2
dev.off()
