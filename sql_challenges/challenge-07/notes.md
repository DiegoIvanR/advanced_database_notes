Vector search is a way to find information based on meaning (semantics) rather than exact keyword matches.

1. Convert text into vectors (embeddings)
Each piece of text (e.g., a paragraph) is transformed into a list of numbers called a vector embedding.
This is done using an AI model (like SentenceTransformer).
The vector captures the meaning of the text.
 Example:
“Cats are animals” and “Felines are creatures” will have similar vectors, even if the words differ.

2. Store vectors in a database
Each text chunk + its vector is stored in a database (here, Oracle 23ai).
The database supports special vector data types and operations.
3. Convert the user query into a vector
When a user asks a question, it is also turned into a vector using the same model.
4. Compare vectors using similarity
The system compares the query vector with stored vectors.
It uses a distance metric (e.g., cosine similarity) to measure closeness:
Closer distance → more similar meaning
Farther distance → less relevant
5. Return the most relevant results
The database sorts results by similarity score.
The top matches are returned—even if they don’t share exact words with the query.

Key Idea

Vector search finds conceptually related content, not just keyword matches.

“fast similarity search” → can match “efficient nearest neighbor retrieval”
“how to make pasta” → returns unrelated results with low similarity