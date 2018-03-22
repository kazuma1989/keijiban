const Datastore = require('@google-cloud/datastore');
const projectId = 'peak-castle-197912';
const datastore = new Datastore({
  projectId
});

const jwt = require('jsonwebtoken');

function postLogin(req, res) {
  const { id, password } = req.body;
  if (!id || !password) {
    res.status(400).send('No id or password.');
    return;
  }

  const key = datastore.key(['user', id]);
  datastore.get(key).then(results => {
    const [user] = results;
    if (!user) {
      res.status(401).send('Unauthorized');
      return;
    }

    if (password === user.password) {
      // sign with default (HMAC SHA256)
      const cert = '123456';  // get private key
      const token = jwt.sign({ sub: id }, cert);

      res.status(200).send({
        token
      });
    } else {
      res.status(401).send('Unauthorized');
    }
  });
}

/**
 * Responds to any HTTP request that can provide a "message" field in the body.
 *
 * @param {!Object} req Cloud Function request context.
 * @param {!Object} res Cloud Function response context.
 */
exports.login = (req, res) => {
  if (req.method === 'POST') {
    postLogin(req, res);
  } else {
    res.send(405).send('Method Not Allowed');
  }
};

