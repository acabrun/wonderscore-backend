module.exports = {
    notFound: (req, res) => {
        res.status(404).send(`This page doesn't exist`);
    }
}