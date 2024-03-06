source = chq.* | sort - @timestamp |  where  LIKE(message, '%sample text%') = true
