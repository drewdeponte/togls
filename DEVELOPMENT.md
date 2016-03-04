Welcome to the development guide for
[Togls](https://github.com/codebreakdown/togls). The hope is that the
following will aid in your development contributions to
[Togls](https://github.com/codebreakdown/togls).

# Where should I start?

We recommend generally that you start with first understanding the
existing features and documentation. These can be obtained by
referencing the [README](https://github.com/codebreakdown/togls) and the
[Wiki](https://github.com/codebreakdown/togls/wiki).

Once you are well versed in concepts, features, and documentation from
an end user standpoint. The next thing we feel is worth exploring is the
architecture. We recommend doing this after understanding it from the
end user standpoint as it should give you context when learning about
the internal concepts.

## The Architecture

### Models

At the core exists three main concepts, the Feature, the Rule, and the
Toggle.

#### Feature

A Feature is the code that provides some functionality coupled with a
unique identifier.

#### Rule

A Rule is conceptually the logic used to determine whether or not to
toggle a feature on or off. This is generally a Rule class provided by
[Togls](https://github.com/codebreakdown/togls/wiki) or a custom Rule
class provided by the end user conforming to the Rule interface.

#### Toggle

Conceptually, a Toggle is a switch that is used to turn something on or
off. In our case it is used to turn a Feature on or off. It does so by
consulting an associated Rule to determine if the Toggle should be on or
off.

The Toggle is really the linch pin of these three concepts as it ties
all three of them together. Forming, a functional feature toggle.

### Repositories

In addition to the three model concepts from above. We also have
Repositories for each of the concepts respectively. They are responsible
for managing and separating the business representations from the
persistance layers.
