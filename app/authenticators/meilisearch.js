import Base from 'ember-simple-auth/authenticators/base';

function makeRequest({ url, key }) {
  const headers = new Headers({
    'Content-Type': 'application/json',
  });

  if (key) {
    headers.append('Authorization', `Bearer ${key}`);
  }

  let _url = new URL('/meilisearch-street-admin/', url);
  console.log(_url.toString());

  // TODO: how to check session?
  const req = new Request(new URL('/meilisearch-street-admin/version', url), {
    headers,
  });

  return fetch(req).then((response) => {
    if (response.ok) {
      return { url, key };
    } else {
      throw new Error('Network response was not OK');
    }
  });
}

export default class MeilisearchAuthenticator extends Base {
  restore(data) {
    return makeRequest(data);
  }

  authenticate(data) {
    return makeRequest(data);
  }
}
