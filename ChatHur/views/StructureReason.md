
# The why behind the structure!

In the current structure, there will be repetition code, for example, all having the chatHistory, ChatViews, and the same @States. This has been done to keep the code simple.

For example, when having two AI providers, one is Apple Intelligence and the other OpenWebUi. The Apple Intelligence current API is very limited and doesn’t support all the features that OpenWebUi has, for example, uploading images. Yes, we could have, for example, in-app settings, a simple JSON file, but working and understanding for a new, ambitious developer might have a harder time understanding the code.

If you have a strong suggestion for a different way, please create an issue with a proposal!


Currently each chat view owns their chathistory.
