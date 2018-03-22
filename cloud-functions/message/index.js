const Datastore = require('@google-cloud/datastore');
const jwt = require('jsonwebtoken');

const projectId = 'peak-castle-197912';
const Bearer = 'Bearer ';
const secret = '123456';

const datastore = new Datastore({
  projectId
});

function authorize(req, res) {
  const Authorization = req.get('Authorization');
  if (!Authorization || !Authorization.startsWith(Bearer)) {
    res.status(401).send('Unauthorized');
    return;
  }

  let decoded;
  try {
  	const token = Authorization.slice(Bearer.length);
    decoded = jwt.verify(token, secret);
  } catch (error) {
    console.log(error);
    res.status(401).send('Unauthorized');
    return;
  }

  const { sub } = decoded;
  if (!sub) {
    res.status(401).send('Unauthorized');
    return;
  }

  return decoded;
}

function postMessage(req, res) {
  const { sub } = authorize(req, res);
  const { body } = req.body;
  if (!body) {
    res.status(400).send('No body.');
    return;
  }

  const key = datastore.key('message');
  const entity = {
    key,
    data: [
      {
        name: 'created',
        value: new Date().toJSON(),
      },
      {
        name: 'body',
        value: body,
        excludeFromIndexes: true,
      },
      {
        name: 'contributor',
        value: sub,
      },
    ],
  };

  datastore
    .save(entity)
    .then(() => {
      console.log(`Message ${key.id} created successfully.`);
      res.status(200).send(key.id);
    })
    .catch(err => {
      console.error('ERROR:', err);
      res.status(500).send('Failed');
    });
}

function getMessage(req, res) {
  if (req.query.id) {
    getById(req, res);
  } else {
    queryAll(req, res);
  }
}

function queryAll(req, res) {
  const query = datastore
    .createQuery('message')
    .order('created', {
      descending: true,
    });

  datastore.runQuery(query).then(results => {
    // message entities found.
    const [messages] = results;
    messages.forEach(message => {
      const { id } = message[datastore.KEY];
      message.id = parseInt(id);
    });

    res.status(200).send(messages);
  });
}

function getById(req, res) {
  const { id } = req.query;

  const key = datastore.key(['message', parseInt(id)]);
  datastore.get(key).then(results => {
    const [message] = results;
    if (!message) {
      res.status(404).send('Not Found');
      return;
    }

    const { id } = message[datastore.KEY];
    message.id = parseInt(id);

    res.status(200).send(message);
  });
}

function putMessage(req, res) {
  const { body } = req.body;
  let id;
  if (req.path) {
    [, id] = req.path.split('/');
  } else {
    res.status(400).send('ID is required');
  }

  const key = datastore.key(['message', parseInt(id)]);

  datastore.get(key).then(results => {
    const [message] = results;
    if (!message) {
      res.status(404).send('Not Found');
      return;
    }

    const { sub } = authorize(req, res);
    if (message.contributor !== sub) {
      res.status(403).send('Forbidden');
      return;
    }

    message.updated = new Date().toJSON();
    message.body = body;
    const entity = {
      key,
      data: message,
    };
    datastore
      .update(entity)
      .then(() => {
        res.status(200).send(`OK ${key.id}`);
      })
      .catch(err => {
        console.error('ERROR:', err);
        res.status(500).send('Failed');
      });
  });
}

function deleteMessage(req, res) {
  let id;
  if (req.path) {
    [, id] = req.path.split('/');
  } else {
    res.status(400).send('ID is required');
    return;
  }

  const key = datastore.key(['message', parseInt(id)]);

  datastore.get(key).then(results => {
    const [message] = results;
    if (!message) {
      res.status(404).send('Not Found');
      return;
    }

    const { sub } = authorize(req, res);
    if (message.contributor !== sub) {
      res.status(403).send('Forbidden');
      return;
    }

    datastore.delete(key).then(() => {
      res.status(200).send(`${key.id} was deleted.`);
    });
  });
}

/**
 * Responds to any HTTP request that can provide a "message" field in the body.
 *
 * @param {!Object} req Cloud Function request context.
 * @param {!Object} res Cloud Function response context.
 */
exports.message = (req, res) => {
  const decoded = authorize(req, res);
  if (!decoded) {
    return;
  }

  if (req.method === 'POST') {
    postMessage(req, res);
  } else if (req.method === 'GET') {
    getMessage(req, res);
  } else if (req.method === 'PUT') {
    putMessage(req, res);
  } else if (req.method === 'DELETE') {
    deleteMessage(req, res);
  } else {
    res.send(405).send('Method Not Allowed');
  }
};

