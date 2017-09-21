context("fusion")

test_that("fusion layer works", {

  qry <- data.frame(select = 'geometry',
                    from = '1ertEwm-1bMBhpEwHhtNYT47HQ9k2ki_6sRa-UQ')

  m <- google_map(key = 'abc') %>%
    add_fusion(query = qry)

  expect_true(
    sum(class(m) == c("google_map", "htmlwidget")) == 2
  )

  m <- google_map(key = 'abc') %>%
    add_fusion(query = qry) %>%
    clear_fusion()

  expect_true(
    (m$x$calls[[2]]$functions == "clear_fusion")
  )

})
